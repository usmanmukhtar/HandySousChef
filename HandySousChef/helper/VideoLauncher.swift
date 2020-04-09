//
//  VideoLauncher.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 07/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

enum stateOfVC {
    case minimized
    case fullScreen
    case hidden
}
enum Direction {
    case up
    case left
    case none
}

protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
    func setPreferStatusBarHidden(_ preferHidden: Bool)
}

class PlayerView: UIView, UIGestureRecognizerDelegate {

    @IBOutlet weak var player: UIView!
    @IBOutlet weak var minimizeButton: UIButton!
    @IBOutlet weak var playerView: WKYTPlayerView!
    
    var videoID: String! = "BVGKskYZrw8"
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.none
    
    //MARK: Methods
    func customization() {
        self.backgroundColor = UIColor.clear
        self.player.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView), name: NSNotification.Name("open"), object: nil)
    }
    
    func animate()  {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, animations: {
                self.minimizeButton.alpha = 1
                self.player.transform = CGAffineTransform.identity
                self.delegate?.setPreferStatusBarHidden(true)
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.delegate?.setPreferStatusBarHidden(false)
                self.minimizeButton.alpha = 0
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.player.bounds.width/4, y: -self.player.bounds.height/4))
                self.player.transform = trasform
            })
        default: break
        }
    }
    
    func changeValues(scaleFactor: CGFloat) {
        self.minimizeButton.alpha = 1 - scaleFactor
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.player.bounds.width / 4 * scaleFactor), y: -(self.player.bounds.height / 4 * scaleFactor)))
        self.player.transform = trasform
    }

    @objc func tapPlayView()  {
        self.state = .fullScreen
        self.delegate?.didmaximize()
        self.animate()
        playerView.load(withVideoId: videoID)
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.changeValues(scaleFactor: factor)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            self.delegate?.didEndedSwipe(toState: self.state)
//            if self.state == .hidden {
//                self.videoPlayer.pause()
//            }
        }
    }
    @IBAction func minimize(_ sender: Any) {
        self.state = .minimized
        self.delegate?.didMinimize()
        self.animate()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
