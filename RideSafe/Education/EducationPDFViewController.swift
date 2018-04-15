//
//  EducationPDFViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 14/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit
import SDWebImage


class EducationPDFViewController: RideSafeViewController {
    @IBOutlet weak var educationPdfTableView: UITableView!
    var mediaList: [Media] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.educationPdfTableView.register(UINib(nibName: "PDFTableViewCell", bundle: nil), forCellReuseIdentifier: "PDFTableViewCellIdentifier")
        educationPdfTableView.tableFooterView = UIView()
        loadData()
        
        educationPdfTableView.estimatedRowHeight = 120.0
        educationPdfTableView.rowHeight = UITableViewAutomaticDimension

    }
    
    func loadData() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getEducationalMediaListByType, params: ["type": "PDF"])
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
        educationPdfTableView.reloadData()
    }
}

extension EducationPDFViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mediaList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PDFTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PDFTableViewCellIdentifier") as! PDFTableViewCell
        let media: Media = self.mediaList[indexPath.row]
        
        cell.pdfTitleLabel.text = media.title
        cell.pdfDateLabel.text = media.postedOn
        cell.pdfDiscription.text = media.description
        cell
        .pdfIconImageView.image = #imageLiteral(resourceName: "pdf")
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let openPdfViewController: OpenPdfViewController = self.storyboard?.instantiateViewController(withIdentifier: "OpenPdfViewController") as! OpenPdfViewController
        openPdfViewController.media = self.mediaList[indexPath.row]
        
        self.navigationController?.pushViewController(openPdfViewController, animated: true)
    }
}
