//
//  DescriptionCell.swift
//  MovieApp
//
//  Created by Emil Guseynov on 19.12.2022.
//

import UIKit

class OverviewCell: UITableViewCell {
    
    var overviewLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Colors.background
        overviewLabel = UILabel(text: "Description\nDescription", font: .systemFont(ofSize: 14), numberOfLines: 0)
        overviewLabel.textColor = Colors.subtitle
        contentView.addSubview(overviewLabel)
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        overviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        overviewLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -30).isActive = true
        overviewLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40).isActive = true
        
    }
    
    func configure(overview: String) {
        overviewLabel.text = overview
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
