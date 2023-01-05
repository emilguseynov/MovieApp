//
//  MainScreenViewController.swift
//  MovieApp
//
//  Created by Emil Guseynov on 13.10.2022.
//

import UIKit

final class MainScreenCollectionViewController: UICollectionViewController {
    
    var headerId = "headerId"
    
    var sections: [ContentType : Section] = [:]
    var favoriteSection = Section(type: .favorite, items: [])
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Result>?
    
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        navControllerSetup()
        loadInitialData()
        
    }
    
    fileprivate func loadInitialData() {
        
        var moviesSection: Section!
        var tvShowsSection: Section!
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchPopularMovies { data, err in
            if let err = err {
                print(err)
                return
            }
            guard let movies = data?.results else { return }
            moviesSection = Section(type: .movies, items: movies)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchPopularTVShows { data, err in
            if let err = err {
                print(err)
                return
            }
            guard let tvShows = data?.results else { return }
            tvShowsSection = Section(type: .tvShows, items: tvShows)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            
            self?.sections[.movies] = moviesSection
            self?.sections[.tvShows] = tvShowsSection
            self?.sections[.favorite] = self?.favoriteSection
            
            self?.collectionViewSetup()
            self?.createDataSource()
            self?.reloadData()
        }
    }
    
    fileprivate func navControllerSetup() {
        title = "MainScreen"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    fileprivate func collectionViewSetup() {
        
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.reloadData()
        collectionView.backgroundColor = Colors.background
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseId)
        
    }
    
    fileprivate func createLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            switch sectionIndex {
            case 0:
                let section: NSCollectionLayoutSection = self.createMovieSection()
                section.boundarySupplementaryItems = self.headerItem()
                return section
            case 1:
                let section: NSCollectionLayoutSection = self.createSmallSection()
                section.boundarySupplementaryItems = self.headerItem()
                return section
            default:
                let section: NSCollectionLayoutSection = self.createSmallSection()
                section.boundarySupplementaryItems = self.headerItem()
                return section
            }
        }
        return layout
    }
    
    fileprivate func createMovieSection() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .estimated(170),
                heightDimension: .estimated(310)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    fileprivate func createSmallSection() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .estimated(150),
                heightDimension: .estimated(270)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    fileprivate func createDataSource() {
        
        //configuration of supplementary view
        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: HeaderView.elementKind) { supplementaryView, elementKind, indexPath in
            
            switch indexPath.section {
            case 0:
                supplementaryView.configure(text: ContentType.movies.rawValue)
            case 1:
                supplementaryView.configure(text: ContentType.tvShows.rawValue)
            default:
                supplementaryView.configure(text: ContentType.favorite.rawValue)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Result>(collectionView: collectionView, cellProvider: { collectionView, indexPath, data in
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseId, for: indexPath) as? ContentCell {
                cell.data = data
                return cell
            }
            
            return UICollectionViewCell()
        })
        
        //supplementary view dequeuing
        dataSource?.supplementaryViewProvider = {(view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    fileprivate func headerItem() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(28)),
            elementKind: HeaderView.elementKind,
            alignment: .topLeading)
        return [headerElement]
    }
    
    fileprivate func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Result>()
        
        var movies, tvShows, favorite: Section!
        
        let queue = DispatchQueue(label: "append-queue", attributes: .concurrent)
        
        queue.sync(flags: .barrier) {
            for section in sections.values {
                switch section.type {
                case .movies: movies = section
                case .tvShows: tvShows = section
                default: favorite = section
                }
            }
        }
        
        queue.async { [weak self] in
            snapshot.appendSections([movies, tvShows, favorite])
            
            snapshot.appendItems(movies.items, toSection: movies)
            snapshot.appendItems(tvShows.items, toSection: tvShows)
            snapshot.appendItems(favorite.items, toSection: favorite)
            
            self?.dataSource?.apply(snapshot)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data: Result!
        let section: Section!
        
        switch indexPath.section {
        case 0:
            section = sections[.movies]
            data = section?.items[indexPath.item]
        case 1:
            section = sections[.tvShows]
            data = section.items[indexPath.item]
        default:
            section = sections[.favorite]
            data = section.items[indexPath.item]
        }
        
        let viewController = DetailedViewController(data: data)
        viewController.delegate = self

        navigationController?.pushViewController(viewController, animated: true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension MainScreenCollectionViewController: FavoriteDelegate {
    func didAddToFavorite(data: Result) {
        
        var data = data
        data.forFavorites = true
        guard let favorites = sections[.favorite] else { return }
        
        if favorites.items.contains(data) {
            let alert = UIAlertController(
                title: "Oops!",
                message: "\(data.name ?? data.title ?? "Movie/TV Show") is already added to favorites",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            sections[.favorite]?.items.insert(data, at: 0)
            reloadData()
        }
    }
}
