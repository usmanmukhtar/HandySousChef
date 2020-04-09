//
//  RecommendationCollectionViewCell.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 05/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {
    
    var isBtnCloseTapped = false
    private var initialFrame: CGRect?
    private var initialCornerRadius: CGFloat?

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgTumbNail: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.insertSubview(blurView, at: 0)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        mainView.layer.cornerRadius = 25
        mainView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
        blurView.heightAnchor.constraint(equalTo: viewContainer.heightAnchor),
        blurView.widthAnchor.constraint(equalTo: viewContainer.widthAnchor),
        ])
    }

}
