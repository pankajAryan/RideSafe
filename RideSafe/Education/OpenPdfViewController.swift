//
//  OpenPdfViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 17/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import WebKit

class OpenPdfViewController: UIViewController, WKNavigationDelegate {

    var pdfWebView: WKWebView!
    var media: Media?

    override func viewDidLoad() {
        super.viewDidLoad()
        pdfWebView = WKWebView.init(frame: self.view.bounds, configuration: WKWebViewConfiguration())
        self.view.addSubview(pdfWebView)
        
        self.title = media?.title
        
        let website = media?.mediaURL
        let reqURL =  URL(string: website!)
        let request = URLRequest(url: reqURL!)
        
        pdfWebView.load(request)
        pdfWebView.navigationDelegate = self
        setBackButton()
        SwiftLoader.show(animated: true)
    }

    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        SwiftLoader.hide()
    }
}
