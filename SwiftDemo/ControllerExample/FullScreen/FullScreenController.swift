//
//  FullScreenController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

class FullScreenNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(FullScreenViewController(nibName: nil, bundle: nil), animated: false)
    }
    
    override func topOffset() -> CGFloat {
        return 0
    }
    
    override func transitionDuration() -> TimeInterval {
        return 0.5
    }
        
    override func shouldRoundTopCorners() -> Bool {
        return false
    }
    
    override func showDragIndicator() -> Bool {
        return false
    }
    
    override func allowScreenEdgeInteractive() -> Bool {
        return true
    }
    
}


fileprivate class FullScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Full Screen"
        
        let rightItem = UIBarButtonItem(title: "NEXT", style: .plain, target: self, action: #selector(nextAction))
        navigationItem.rightBarButtonItem = rightItem
        
        let label = UILabel(frame: .zero)
        label.text = "Drag To Dismiss"
        view.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.center.equalTo(view)
        }
    }
    
    @objc func nextAction() {
        let nextPage = FullScreenViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(nextPage, animated: true)
    }
    
}
