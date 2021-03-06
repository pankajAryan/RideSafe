//
//  EducationVideoViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 14/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit
import SDWebImage

class EducationVideoViewController: RideSafeViewController {
    @IBOutlet weak var educationVideoTableView: UITableView!
    var mediaList: [Media] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.educationVideoTableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCellIdentifier")
        educationVideoTableView.tableFooterView = UIView()
        educationVideoTableView.estimatedRowHeight = 100.0
        educationVideoTableView.rowHeight = UITableViewAutomaticDimension

        loadData()
    }
    
    func loadData() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getEducationalMediaListByType, params: ["type": "VIDEO"])
            }.then { response -> () in
                let mediaResponse = MediaResponse(dictionary: response as NSDictionary)
                let mediaList = mediaResponse?.responseObject
                self.reloadData(medialist: mediaList!)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    func reloadData(medialist: [Media]) {
        self.mediaList = medialist
        educationVideoTableView.reloadData()
    }
}

extension EducationVideoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showNoRecod( mediaList.count == 0, viewOn: tableView)
        return self.mediaList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:VideoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCellIdentifier") as! VideoTableViewCell!
        let media: Media = self.mediaList[indexPath.row]
        
        cell.videoTitleLabel.text = media.title
        cell.dateTitleLabel.text = media.postedOn
        cell.videoIconImageView.sd_setImage(with: URL(string: media.thumbnailURL!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let youtubeViewController: YoutubeVideoViewController = self.storyboard?.instantiateViewController(withIdentifier: "YoutubeVideoViewController") as! YoutubeVideoViewController
        youtubeViewController.media = self.mediaList[indexPath.row]
        
        self.navigationController?.pushViewController(youtubeViewController, animated: true)
    }
}
