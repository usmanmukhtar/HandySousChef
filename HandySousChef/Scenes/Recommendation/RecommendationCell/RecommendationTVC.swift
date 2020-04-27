//
//  RecommendationTVC.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 20/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit
import SkeletonView
import SDWebImage
import AnimatedCollectionViewLayout
import SDWebImageFLPlugin

class RecommendationTVC: UITableViewCell {

    //MARK:- outlets
    @IBOutlet weak var collView: UICollectionView!
    
    //MARK:- variables
    var videos:[VideoData] = [VideoData]()
    var selectedVideo: VideoData?
    var videoArrayComplete: Bool = false
    var ChannelId: String = ""
    var queryParam: String? = nil
    
    //MARK:- constants
    let videoModel:VideoDataModel = VideoDataModel()
    
    
    //MARK:- objc func
    @objc func onbtnYoutube(_ sender: UIButton){
        UIApplication.shared.open(NSURL(string: "https://www.youtube.com/channel/\(ChannelId)")! as URL, options: [:], completionHandler: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(){
        
        //collection view init
        collView.delegate = self
        collView.dataSource = self
        
        //collection view animation
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator()
        layout.scrollDirection = .horizontal
        collView.collectionViewLayout = layout
        
        //register collection view cell
        self.collView.register(UINib(nibName: "RecommendationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendationCollectionViewCell")
        
        //video model class config
        self.videoModel.delegate = self
        if let query = queryParam {
            videoModel.getFeedVideos(param: query)
        }
    }
    
}

extension RecommendationTVC: SkeletonCollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentifier"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "RecommendationCollectionViewCell", for: indexPath) as! RecommendationCollectionViewCell
        
        if videos.count == 0 {
            cell.imgTumbNail.showAnimatedGradientSkeleton()
            cell.lblName.showAnimatedGradientSkeleton()
            cell.lblChannel.showAnimatedGradientSkeleton()
            cell.btnYoutube.showAnimatedGradientSkeleton()
            
            return cell
        }

        let videoTitle = videos[indexPath.row].videoTitle
        let ChannelTitle = videos[indexPath.row].videoChannelName
        let videoUrlString = videos[indexPath.row].videoThumbnailUrl
        ChannelId = videos[indexPath.row].videoChannelId
        let url = URL(string: videoUrlString)!
        
        if self.videoArrayComplete {
            cell.imgTumbNail.hideSkeleton()
            cell.lblName.hideSkeleton()
            cell.lblChannel.hideSkeleton()
            cell.btnYoutube.hideSkeleton()
            cell.lblName.text = videoTitle
            cell.imgTumbNail.sd_setImage(with: url, placeholderImage: UIImage(named: "loading"), options: [.progressiveLoad, .continueInBackground])
            cell.lblChannel.text = "By: \(ChannelTitle)"
            cell.btnYoutube.addTarget(self, action: #selector(onbtnYoutube), for: .touchUpInside)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        if videos.count != 0 {
            self.selectedVideo = self.videos[indexPath.row]
            NotificationCenter.default.post(name: NSNotification.Name("open"), object: self, userInfo: ["message": self.selectedVideo ?? ""])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}


extension RecommendationTVC: VideoModelDelegate {
    func dataReady() {
        self.videos = self.videoModel.videoArray
        videos.shuffle()
        self.collView.reloadData()
        videoArrayComplete = true
    }
}
