//
//  MealCollectionViewCell.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 03/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {

    var page: SwippingModel? {
        didSet {
            guard let unwrappedPage = page else { return}
            
            imgMeal.image = UIImage(named: unwrappedPage.imageName)
            lblMeal.text = unwrappedPage.mealName
        }
    }
    
    @IBOutlet weak fileprivate var imgMeal: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewMeal: UIView!
    @IBOutlet weak fileprivate var lblMeal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewMeal.layer.shadowColor = UIColor(named: "shadow-color")?.cgColor
        viewMeal.layer.shadowOffset = CGSize(width: -10, height: -10)
        viewMeal.layer.shadowRadius = 20
        viewMeal.layer.shadowOpacity = 0.5
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
    }

}
