//
//  ShareController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import HWPanModal

class ShareViewController: UIViewController {
    
    lazy var closeButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        btn.backgroundColor = UIColor(displayP3Red: 0.976, green: 0.980, blue: 0.980, alpha: 1)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let bgImgView = UIImageView(image: UIImage(named: "bg_share_item"))
        view.addSubview(bgImgView)
        view.addSubview(closeButton)
        
        bgImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(5)
            maker.centerX.equalTo(view)
        }
        
        closeButton.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.height.equalTo(46)
        }
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension ShareViewController {
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .content, height: 300)
    }
    
    override func showDragIndicator() -> Bool {
        return false
    }
    
}
