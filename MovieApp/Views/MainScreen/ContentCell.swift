//
//  ContentCell.swift
//  MovieApp
//
//  Created by Emil Guseynov on 24.12.2022.
//

import UIKit
import SDWebImage

class ContentCell: UICollectionViewCell {
    
    static let reuseId = "contentCell"
    
    var data: Result? {
        willSet {
            
            // movie
            if let name = newValue?.title {
                nameLabel.text = name
                releaseDateLabel.text = newValue?.releaseDate
                
                posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(newValue?.posterPath ?? "")"))
            }
            
            // tvShow
            if let name = newValue?.name {
                nameLabel.text = name
                releaseDateLabel.text = newValue?.firstAirDate
                posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(newValue?.posterPath ?? "")"))
            }
            
        }
    }
    
    var width: CGFloat!
    let aspectRatio = CGFloat(1.5)
    
    let posterImageView = UIImageView()
    
    let nameLabel: UILabel = {
        let label = UILabel(text: "Wonder Woman", font: .boldSystemFont(ofSize: 16), numberOfLines: 2)
        label.textColor = Colors.title
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.subtitle
        label.text = "Dec 16, 2020"
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        posterImageViewSetup()
        
        addSubview(nameLabel)
        addSubview(releaseDateLabel)
        
        constraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func posterImageViewSetup() {
        
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        
        addSubview(posterImageView)
    }
    
    fileprivate func constraints() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor),
            posterImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: aspectRatio),
            
            nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: 20),
            
            releaseDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            releaseDateLabel.heightAnchor.constraint(equalToConstant: 12)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

