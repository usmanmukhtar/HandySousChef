//
//  VideoDataModel.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 11/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit
import Alamofire


protocol VideoModelDelegate {
    func dataReady()
}

class VideoDataModel: NSObject {
    
    let urlString = "https://www.googleapis.com/youtube/v3/search"
    var param: Parameters = [
        "part": "snippet",
//        "q": "Breakfast",
        "maxResults": 20,
        "type": "video",
        "key": "AIzaSyD-NDfLv4j2RgGVl9ZE7f9SwQWGL0QlW7Q"
    ]
    
    var videoArray = [VideoData]()
    var delegate: VideoModelDelegate?
    
    
    func getFeedVideos(param: String) {
        self.param["q"] = param
        
        Alamofire.request(urlString, method: .get, parameters: self.param, encoding: URLEncoding.default).responseJSON { response in

            guard response.result.isSuccess,
                let JSON = response.result.value as? [String: Any] else {
                    
                    
                    if let errorMsg = response.result.error?.localizedDescription, let errorCode = response.result.error?._code {
                        let alert = Alert()
                        alert.msg(message: errorMsg, errorCode: String(errorCode))
                    }
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                
                return
            }
                print("JSON: \(JSON)")
            var arrayOfVideos = [VideoData]()
            
            for video in JSON["items"] as! NSArray{
//                print(video)
                let videoObj = VideoData()
                videoObj.videoId = (video as AnyObject).value(forKeyPath: "id.videoId") as! String
                videoObj.videoTitle = (video as AnyObject).value(forKeyPath: "snippet.title") as! String
                videoObj.videoThumbnailUrl = (video as AnyObject).value(forKeyPath: "snippet.thumbnails.high.url") as! String
                videoObj.videoChannelId = (video as AnyObject).value(forKeyPath: "snippet.channelId") as! String
                videoObj.videoChannelName = (video as AnyObject).value(forKeyPath: "snippet.channelTitle") as! String
                
                arrayOfVideos.append(videoObj)
            }
            
            self.videoArray = arrayOfVideos
            
            if self.delegate != nil {
                self.delegate?.dataReady()
            }
            
        }
    }

    func getVideos() -> [VideoData]{
        
        var videos = [VideoData]()
        
        let video = VideoData()
        video.videoId = "BVGKskYZrw8"
        video.videoTitle = "I DECIDED I'M TAKING A BREAK AFTER PLAYING THIS LEVEL... [SUPER MARIO MAKER 2] [#42]"
        
        videos.append(video)
        
        return videos
    }
}
