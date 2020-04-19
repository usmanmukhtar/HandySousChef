//
//  Recommendation.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 05/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit
import SkeletonView
import SDWebImage
import AnimatedCollectionViewLayout

class Recommendation: UIViewController, PlayerVCDelegate {
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var searchTab: UIView!
    @IBOutlet weak var searchView: UISearchBar!
    
    var videos:[VideoData] = [VideoData]()
    var selectedVideo: VideoData?
    var queryParam = "Breakfast Desi Recipe"
    var videoArrayComplete: Bool = false
    var ChannelId: String = ""
    var message: Int = 0
    
    let videoModel:VideoDataModel = VideoDataModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Suggestions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collView.keyboardDismissMode = .onDrag
        
        //collection view animation
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator()
        layout.scrollDirection = .horizontal
        collView.collectionViewLayout = layout
        self.customization()
        
        self.collView.register(UINib(nibName: "RecommendationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendationCollectionViewCell")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.playerView)
        }
    }
    
    //MARK: Properties
    @IBOutlet var playerView: PlayerView!
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let minimizedOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)

    //btnObjects
    @objc func onbtnYoutube(_ sender: UIButton){
        UIApplication.shared.open(NSURL(string: "https://www.youtube.com/channel/\(ChannelId)")! as URL, options: [:], completionHandler: nil)
    }
    
    
    //Methods
    func customization() {
        
        switch message {
        case 0:
            queryParam = "Breakfast Desi Recipe"
        case 1:
            queryParam = "Lunch Desi Recipe"
        case 2:
            queryParam = "Dinner Desi Recipe"
        default:
            queryParam = "Desi Recipe"
        }
        
        self.searchTab.layer.shadowRadius = 20
        self.searchTab.layer.shadowColor = UIColor(named: "shadow-color")?.cgColor
        self.searchTab.layer.shadowOpacity = 0.5
        self.searchTab.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.searchTab.layer.shadowPath = UIBezierPath(rect: searchTab.bounds).cgPath
        
        searchView.delegate = self
        if let textFieldInsideSearchBar = self.searchView.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView{

                //Magnifying glass
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = .white
        }
        
        //PLayerView setup
        self.playerView.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        self.playerView.delegate = self
        self.videoModel.delegate = self
        videoModel.getFeedVideos(param: queryParam)
    }
    
    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
                self.playerView.frame.origin = self.fullScreenOrigin
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.minimizedOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.hiddenOrigin
            })
        }
    }
    
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
    
    //MARK: Delegate methods
    func didMinimize() {
        self.animatePlayView(toState: .minimized)
    }
    
    func didmaximize(){
        self.animatePlayView(toState: .fullScreen)
    }
    
    func didEndedSwipe(toState: stateOfVC){
        self.animatePlayView(toState: toState)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
        switch toState {
        case .fullScreen:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.playerView.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
        case .minimized:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }
    
    func setPreferStatusBarHidden(_ preferHidden: Bool) {
        self.isHidden = preferHidden
    }
    
    var isHidden = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
}

extension Recommendation: SkeletonCollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
            cell.imgTumbNail.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad, .continueInBackground])
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
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RecipieDesc") as! RecipieDesc
//        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 600)
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

extension Recommendation: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VideoList") as! VideoList
        nextViewController.queryParam = (searchBar.text == "" ? "Cooking recipe" : searchBar.text ?? "Cooking recipe")
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

extension Recommendation: VideoModelDelegate {
    func dataReady() {
        self.videos = self.videoModel.videoArray
        self.collView.reloadData()
        videoArrayComplete = true
    }
}
