//
//  OpenPdfViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 17/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import WebKit

class OpenPdfViewController: UIViewController {

    @IBOutlet weak var pdfWebView: WKWebView!
    var media: Media?

    override func viewDidLoad() {
        super.viewDidLoad()

        let website = media?.mediaURL
        let reqURL =  URL(string: website!)
        let request = URLRequest(url: reqURL!)
        
        pdfWebView.load(request)
    }

}
