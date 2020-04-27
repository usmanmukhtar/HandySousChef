//
//  VideoList.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 11/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SDWebImageFLPlugin
import SkeletonView

class VideoList: UIViewController, VideoModelDelegate {
    
    @IBOutlet weak var videoList: UITableView!
    
    var videos:[VideoData] = [VideoData]()
    var selectedVideo: VideoData?
    var queryParam = "Recipe"
    var videoArrayComplete: Bool = false
    
    
    let videoModel:VideoDataModel = VideoDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoModel.delegate = self
        videoModel.getFeedVideos(param: queryParam)
        
        self.videoList.dataSource = self
        self.videoList.delegate = self
    }
    
    func dataReady() {
        self.videos = self.videoModel.videoArray
        self.videoList.reloadData()
        videoArrayComplete = true
    }
}

extension VideoList: UITableViewDelegate, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videos.count != 0 {
            return videos.count
        }
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentifier"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = videoList.dequeueReusableCell(withIdentifier: "VideoListCell")!
        
        if videos.count == 0 {
            cell.showAnimatedGradientSkeleton()
            
            return cell
        }
        
        let videoTitle = videos[indexPath.row].videoTitle
        let label = cell.viewWithTag(2) as! UILabel
//        label.showAnimatedGradientSkeleton()
        
        
        let videoUrlString = videos[indexPath.row].videoThumbnailUrl
        
        let url = URL(string: videoUrlString)!
        let imageView = cell.viewWithTag(1) as! UIImageView

        if self.videoArrayComplete {
            cell.hideSkeleton()
            label.text = videoTitle
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "loading"), options: [.progressiveLoad, .continueInBackground])
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.size.width / 320 * 180)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if videos.count != 0 {
            self.selectedVideo = self.videos[indexPath.row]
            NotificationCenter.default.post(name: NSNotification.Name("open"), object: self, userInfo: ["message": self.selectedVideo ?? ""])
        }
    }

}
