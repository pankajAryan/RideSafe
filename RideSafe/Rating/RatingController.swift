//
//  RatingController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 15/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import Cosmos

class RatingController: RideSafeViewController {

    @IBOutlet weak var ratingView: CosmosView!
    var drivingIssueId = ""
    private var startRating = "0.5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Give Feedback"
        setBackButton()
        ratingView.didFinishTouchingCosmos = didFinishTouchingCosmos // Register touch handlers
    }
    
    @IBAction func submitRating(_ sender: UIButton) {
        NetworkManager().doServiceCall(serviceType: .rateDrivingIssueByCitizen, params:["drivingIssueId": drivingIssueId, "rating": startRating]).then { response -> () in
            self.showToast(message: "Rating Submitted Successfully.")
            }.catch { error  in
                self.showError(error: error)
        }
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        startRating = String(format: "%.2f", rating)
        ratingView.rating = rating
    }
}
