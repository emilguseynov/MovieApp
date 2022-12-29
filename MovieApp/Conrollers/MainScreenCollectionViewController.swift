//
//  MainScreenViewController.swift
//  MovieApp
//
//  Created by Emil Guseynov on 13.10.2022.
//

import UIKit

class MainScreenCollectionViewController: UICollectionViewController {
    
    var headerId = "headerId"
    
    var sections = [Section]()
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
        
        dispatchGroup.notify(queue: .main) {
            self.sections.append(moviesSection)
            self.sections.append(tvShowsSection)
            
            self.collectionViewSetup()
            self.createDataSource()
            self.reloadData()
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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
            let model = self.sections[sectionIndex]
            
            switch model.type {
            case .movies:
                let section: NSCollectionLayoutSection = self.createMoviesSection()
                section.boundarySupplementaryItems = self.headerItem()
                return section
            default:
                let section: NSCollectionLayoutSection = self.createTVShowsSection()
                section.boundarySupplementaryItems = self.headerItem()
                return section
            }
        }
        return layout
    }
    
    fileprivate func createMoviesSection() -> NSCollectionLayoutSection{
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
    
    fileprivate func createTVShowsSection() -> NSCollectionLayoutSection{
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
        section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    fileprivate func createDataSource() {
        
        //configuration of supplementary view
        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: HeaderView.elementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.configure(text: self.sections[indexPath.section].type.rawValue)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Result>(collectionView: collectionView, cellProvider: { collectionView, indexPath, data in
            
            switch self.sections[indexPath.section].type {
            case .movies:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseId, for: indexPath) as? ContentCell {
                    cell.data = data
                    return cell
                }
            default:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseId, for: indexPath) as? ContentCell {
                    cell.data = data
                    return cell
                }
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
        
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DetailedViewController(
            data: sections[indexPath.section].items[indexPath.item])
        
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
