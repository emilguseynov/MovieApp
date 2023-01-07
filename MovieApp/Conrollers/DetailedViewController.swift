//
//  DetailedScrollViewController.swift
//  MovieApp
//
//  Created by Emil Guseynov on 16.12.2022.
//

import UIKit

protocol FavoriteDelegate {
    func didAddToFavorite(data: Result)
}

final class DetailedViewController: UIViewController {
    
    let tableView = UITableView()

    var url: URL!
    var data: Result
    
    var contentType: ContentType!
    var name: String!
    var votes = Double(0)
    
    var delegate: FavoriteDelegate?
    
    lazy var genresDictionary = [Int : String]()
        
    // MARK: - Initialization
    
    init(data: Result) {
        self.data = data
        
        //movies names are specified in .title
        //tv shows names are specified in .name
        if let name = data.title {
            contentType = .movie
            self.name = name
        } else if let name = data.name {
            contentType = .tvShow
            self.name = name
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        
        navigationControllerSetup()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Colors.background
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        getListOfGenres()
    }
    
    // MARK: - NavigationBar size setup
    
    override func willMove(toParent parent: UIViewController?) {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Actions
    
    @objc func didTapBookmark() {
        delegate?.didAddToFavorite(data: data)
    }
    
    // MARK: - Private Methods
    
    private func watchNowButtonTapped() {
        var urlString = "https://www.themoviedb.org/\(contentType.rawValue)/\(data.id)-"
        
        urlString.append(name.lowercased().replacingOccurrences(of: " ", with: "-"))
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func getListOfGenres() {
        let genres = Bundle.main.decode(Genres.self, from: "genreIDs.json")
        
        for genre in genres.genres {
            genresDictionary[genre.id] = genre.name
        }
    }
    
    private func createShortDescription() -> String {
        var shortDescriptionArray = [String]()
        if let releaseDate = data.releaseDate {
            
            //droping last 6 symbols "YYYY(-DD-MM)"
            let year = String(releaseDate.dropLast(6))
            shortDescriptionArray.append(year)
            
        } else if let firstAirDate = data.firstAirDate {
            let year = String(firstAirDate.dropLast(6))
            shortDescriptionArray.append(year)
        }
        
        var genres = [String]()
        
        for id in data.genreIds {
            if let genre = genresDictionary[id]{
                genres.append(genre)
            }
        }
        
        let genresString = genres.joined(separator: ", ")
        shortDescriptionArray.append(genresString)
        
        return shortDescriptionArray.joined(separator: " • ")
    }
    
    private func navigationControllerSetup() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = .gray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(didTapBookmark))
    }
}

//MARK: - Delegate & DataSource

extension DetailedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = ImageCell()
            guard let imageId = data.backdropPath else { return cell }
            
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/original\(imageId)")
            cell.configure(imageUrl: imageUrl)
            return cell
        case 1:
            let cell = NameCell()
            if let voteNum = data.voteAverage {
                votes = voteNum
            }
            cell.configure(name: name, shortDescription: createShortDescription(), votes: votes)
            return cell
        case 2:
            let cell = OverviewCell()
            cell.configure(overview: data.overview)
            return cell
        default:
            let cell = ButtonCell()
            cell.button.addAction(UIAction(handler: { _ in
                self.watchNowButtonTapped()
            }), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return view.frame.width
        case 1, 2: return UITableView.automaticDimension
        default: return 100
        }
    }
}

extension DetailedViewController {
    enum ContentType: String {
        case movie = "movie"
        case tvShow = "tv"
    }
}
