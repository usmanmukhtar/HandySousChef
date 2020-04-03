//
//  ViewController.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 02/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    let pages = [
    SwippingModel(imageName: "meal-1", mealName: "Breakfast"),
    SwippingModel(imageName: "meal-2", mealName: "Lunch"),
    SwippingModel(imageName: "meal-3", mealName: "Dinner")]
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collView: UICollectionView!
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collView.register(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCollectionViewCell")
        collView.isPagingEnabled = true
    }
    
    @IBAction func btnNext(_ sender: Any) {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    @IBAction func btnPrev(_ sender: Any) {
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        pageControl.currentPage = prevIndex
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath) as! MealCollectionViewCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collView.frame.width, height: collView.frame.height)
    }
}