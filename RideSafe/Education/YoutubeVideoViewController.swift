//
//  YoutubeVideoViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 17/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import YouTubePlayer_Swift

class YoutubeVideoViewController: RideSafeViewController {

    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDateTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var media: Media?
    override func viewDidLoad() {
        super.viewDidLoad()
        let myVideoURL = NSURL(string: (media?.mediaURL)!)
        youtubePlayerView.loadVideoURL(myVideoURL! as URL)
        youtubePlayerView.delegate = self
        self.title = media?.title
        videoTitleLabel.text = media?.title
        videoDateTimeLabel.text = media?.postedOn
        descriptionLabel.text = media?.description
        setBackButton()
        SwiftLoader.show(animated: true)

    }
}

extension YoutubeVideoViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        SwiftLoader.hide()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        
    }
    
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        
    }
    
    
}
