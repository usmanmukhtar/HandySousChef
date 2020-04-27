//
//  RecommendationCollectionViewCell.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 05/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit
import SDWebImageFLPlugin

class RecommendationCollectionViewCell: UICollectionViewCell {
    
    var isBtnCloseTapped = false
    private var initialFrame: CGRect?
    private var initialCornerRadius: CGFloat?

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgTumbNail: SDAnimatedImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblChannel: UILabel!
    @IBOutlet weak var btnYoutube: UIButton!
    @IBOutlet weak var imgThumbNailHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        mainView.layer.cornerRadius = 25
        mainView.clipsToBounds = true
        
        self.layer.shadowColor = UIColor(named: "shadow-color")?.cgColor
        self.layer.shadowOffset = CGSize(width: -8, height: -8)
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
        
        imgThumbNailHeight.constant = self.mainView.frame.size.width / 480 * 240
//        imgThumbNail.layoutIfNeeded()
    }

}
