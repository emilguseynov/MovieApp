//
//  ImageCell.swift
//  MovieApp
//
//  Created by Emil Guseynov on 16.12.2022.
//

import UIKit

class ImageCell: UITableViewCell {
    let posterImageView = UIImageView()
//    let posterImageLayer = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        
//        posterImageLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        posterImageLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        posterImageView.layer.addSublayer(posterImageLayer)
//
//        let animationGroup = CAAnimationGroup()
        
        
        contentView.backgroundColor = Colors.background
        contentView.addSubview(posterImageView)

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding = CGFloat(16)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageUrl: URL?) {
        posterImageView.sd_setImage(with: imageUrl)
    }
    
}
