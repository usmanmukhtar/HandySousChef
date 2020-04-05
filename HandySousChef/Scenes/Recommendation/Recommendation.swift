//
//  Recommendation.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 05/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit

class Recommendation: UIViewController{
    
    @IBOutlet weak var collView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Today"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.collView.register(UINib(nibName: "RecommendationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendationCollectionViewCell")
    }
    
}

extension Recommendation: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "RecommendationCollectionViewCell", for: indexPath) as! RecommendationCollectionViewCell
//        let page = pages[indexPath.item]
//        cell.page = page
        return cell
    }
}
