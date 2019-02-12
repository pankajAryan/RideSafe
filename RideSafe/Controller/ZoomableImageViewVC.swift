//
//  ZoomableImageViewVC.swift
//  JK RideSafe
//
//  Created by Rahul Chaudhary on 12/02/19.
//  Copyright © 2019 Mobiquel. All rights reserved.
//

import UIKit

class ZoomableImageViewVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    
    var img : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = img
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ZoomableImageViewVC: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
}
