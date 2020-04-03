//
//  SwipingController.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 03/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit


class SwippingController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collView: UICollectionView!
    
    let pages = [
    SwippingModel(imageName: "meal-1", mealName: "Breakfast"),
    SwippingModel(imageName: "meal-2", mealName: "Lunch"),
    SwippingModel(imageName: "meal-3", mealName: "Dinner")]
    
//    let imageNames = ["meal-1", "meal-2", "meal-3"]
//    let mealNames = ["Breakfast", "Lunch", "Dinner"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collView.register(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCollectionViewCell")
        collectionView?.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath) as! MealCollectionViewCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
}
