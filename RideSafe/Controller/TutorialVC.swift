//
//  TutorialVC.swift
//  JK RideSafe
//
//  Created by Rahul Chaudhary on 14/07/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class TutorialVC: RideSafeViewController {

    @IBOutlet weak var pageControl : UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TutorialVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        if pageNumber > 4 {
            return
        }
        pageControl.currentPage = Int(pageNumber)
    }
}
