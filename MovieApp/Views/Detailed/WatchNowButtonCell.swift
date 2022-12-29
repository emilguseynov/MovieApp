//
//  ExpandedHitAreaButton.swift
//  MovieApp
//
//  Created by Emil Guseynov on 14.12.2022.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    var button: WatchNowButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Colors.background
        
        button = WatchNowButton()
        contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//subclassing UIbutton just to play around with responder chain :)
class WatchNowButton: UIButton {
    
    var touchAreaPadding: (x: CGFloat, y: CGFloat)?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let expansion = touchAreaPadding else {
            return super.point(inside: point, with: event)
        }
        
        let newRect = CGRectInset(bounds, -(expansion.x), -(expansion.y))
        return CGRectContainsPoint(newRect, point)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        touchAreaPadding = (10, 10)
        backgroundColor = Colors.accented
        setTitle("Watch Now", for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
