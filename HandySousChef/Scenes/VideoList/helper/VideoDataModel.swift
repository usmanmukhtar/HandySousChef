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
        "type": "video",
        "videoEmbeddable": "true",
        "key": "Your API Key",
    ]
    
    var videoArray = [VideoData]()
    var delegate: VideoModelDelegate?
    let date = Date()
    let calendar = Calendar.current

    
    func getFeedVideos(param: String, maxResults: Int = 20, order: String = "relevance") {
        
        self.param["maxResults"] = maxResults
        self.param["q"] = param
        self.param["publishedAfter"] = "\(calendar.component(.year, from: date))-01-01T00:00:00Z"
        self.param["order"] = order
        
        
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
            print("JSON: \((JSON["error"] as AnyObject).value(forKeyPath: "message") ?? "nothing")")
            
            if let error = JSON["error"], let errorCode = (error as AnyObject).value(forKeyPath: "code") as? NSNumber{
                let errorMsg = "The request cannot be completed because the quota limit has exceded!"
                let alert = Alert()
                alert.msg(message: errorMsg, errorCode: errorCode.stringValue)
            }else {
                var arrayOfVideos = [VideoData]()
                            
                for video in JSON["items"] as! NSArray{
    //                print(video)
                    let videoObj = VideoData()
                    videoObj.videoId = (video as AnyObject).value(forKeyPath: "id.videoId") as! String
                    videoObj.videoTitle = (video as AnyObject).value(forKeyPath: "snippet.title") as! String
                    videoObj.videoDesc = (video as AnyObject).value(forKeyPath: "snippet.description") as! String
                    videoObj.videoThumbnailUrl = (video as AnyObject).value(forKeyPath: "snippet.thumbnails.high.url") as! String
                    videoObj.videoChannelId = (video as AnyObject).value(forKeyPath: "snippet.channelId") as! String
                    videoObj.videoChannelName = (video as AnyObject).value(forKeyPath: "snippet.channelTitle") as! String
                    
                    arrayOfVideos.append(videoObj)
                }
                
                self.videoArray = arrayOfVideos
            }
            
            
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
