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
    
    var mealCount = 0
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSelectMeal: UILabel!
    @IBOutlet weak var lowerStackView: UIStackView!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnLowerStack: UIButton!
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        self.btnLowerStack.tag = pageControl.currentPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: LocalNotification tap
        NotificationCenter.default.addObserver(self,selector: #selector(NotificationTap),
        name: NSNotification.Name(rawValue: "NotificationTap"),
        object: nil)
        
        //btnnext action here
        self.btnLowerStack.tag = pageControl.currentPage
        self.btnLowerStack.addTarget(self, action: #selector(onbtnNext), for: .touchUpInside)
        
        //initial UI
        self.btnLowerStack.layer.cornerRadius = 10
        self.btnLowerStack.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.lblSelectMeal.center.y -= 300
        self.btnRight.center.x += 100
        self.btnRight.layer.shadowColor = UIColor(named: "shadow-color")?.cgColor
        self.btnRight.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.btnRight.layer.shadowRadius = 10
        self.btnRight.layer.shadowOpacity = 0.5
        self.btnLeft.center.x -= 100
        self.btnLeft.layer.shadowColor = UIColor(named: "shadow-color")?.cgColor
        self.btnLeft.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.btnLeft.layer.shadowRadius = 10
        self.btnLeft.layer.shadowOpacity = 0.5
        
        //MARK: background UI
        backgroundViewHeight.constant = UIScreen.main.bounds.height / 2
        UIView.animate(withDuration: 0.5 , animations:{
            self.backgroundView.layoutIfNeeded()
            self.backgroundView.layer.cornerRadius = 10
            self.backgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.lblSelectMeal.center.y += 300
            self.collView.alpha = 1
            self.lowerStackView.alpha = 1
            self.btnRight.center.x -= 100
            self.btnLeft.center.x += 100
        })
        //MARK: Collection view register
        self.collView.register(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCollectionViewCell")
        collView.isPagingEnabled = true
        if let flowLayout = collView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func btnNext(_ sender: Any) {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        self.btnLowerStack.tag = pageControl.currentPage
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    @IBAction func btnPrev(_ sender: Any) {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        self.btnLowerStack.tag = pageControl.currentPage
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func NotificationTap(notification: NSNotification){
      DispatchQueue.main.async
        {
          //Land on Recommendation ViewController
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let vc: Recommendation = storyboard.instantiateViewController(withIdentifier: "Recommendation") as! Recommendation
          self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onbtnNext(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: Recommendation = storyboard.instantiateViewController(withIdentifier: "Recommendation") as! Recommendation
        vc.message = btnLowerStack.tag
        self.navigationController?.pushViewController(vc, animated: true)
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
        return CGSize(width: UIScreen.main.bounds.size.width, height: collView.frame.height)
    }
}
