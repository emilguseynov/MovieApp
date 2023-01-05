//
//  NameCell.swift
//  MovieApp
//
//  Created by Emil Guseynov on 17.12.2022.
//

import UIKit
import Cosmos

class NameCell: UITableViewCell {

    var nameLabel: UILabel!
    var shortDescriptionLabel: UILabel!
    var votesLabel: UILabel!
    var votesStackView: UIStackView!
    var stars: CosmosView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabelSetup()
        shortDescriptionSetup()
        ratesSetup()
        
        contentView.addSubviews([nameLabel, shortDescriptionLabel, votesStackView])
        contentView.backgroundColor = Colors.background
        
        constraints()
        
    }
    
//MARK: - view setups
    fileprivate func nameLabelSetup() {
        nameLabel = UILabel(text: "Movie Name", font: .boldSystemFont(ofSize: 36), numberOfLines: 0)
        nameLabel.textAlignment = .center
        nameLabel.textColor = Colors.title

    }
    
    fileprivate func shortDescriptionSetup() {
        shortDescriptionLabel = UILabel(text: "YYYY • GENRES", font: .boldSystemFont(ofSize: 14), numberOfLines: 0)
        shortDescriptionLabel.textAlignment = .center
        shortDescriptionLabel.textColor = Colors.subtitle
    }
    
    fileprivate func ratesSetup() {
        votesLabel = UILabel(text: "10.0", font: .systemFont(ofSize: 20, weight: .black))
        votesLabel.textColor = UIColor(red: 246/255, green: 195/255, blue: 68/255, alpha: 1)
        
        stars = CosmosView()
        stars.settings.fillMode = .half
        stars.settings.starSize = 16
        stars.settings.updateOnTouch = false
        stars.settings.starMargin = 8
        stars.settings.filledImage = UIImage(named: "filledStar")
        stars.settings.emptyImage = UIImage(named: "emptyStar")
        
        votesStackView = UIStackView(arrangedSubviews: [votesLabel, stars])
        votesStackView.spacing = 8
        votesStackView.alignment = .center
        
    }
    
//MARK: - Constraints
    fileprivate func constraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        shortDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        votesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -30),
            
            shortDescriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor,constant: -30),
            shortDescriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            shortDescriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            votesStackView.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 10),
            votesStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            votesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
    
//MARK: - configure
    func configure(name: String, shortDescription: String, votes: Double) {
        nameLabel.text = name
        shortDescriptionLabel.text = shortDescription
        votesLabel.text = String(votes)
        stars.rating = votes/2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
