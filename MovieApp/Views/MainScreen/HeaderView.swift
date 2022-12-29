//
//  HeaderView.swift
//  MovieApp
//
//  Created by Emil Guseynov on 18.10.2022.
//

import UIKit

class HeaderView: UICollectionReusableView{
    static let elementKind = "header"
    let label = UILabel(text: "Header", font: .boldSystemFont(ofSize: 24))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(text: String) {
        label.text = text
        label.textColor = Colors.title
        addSubview(label)
        
        let inset = CGFloat(4)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset)
            
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
