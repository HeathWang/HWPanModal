//
//  ShoppingCartController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 wangcongling. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import HWPanModal

class ShoppingCartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgView = UIImageView(image: UIImage(named: "bg_shopping"))
        view.addSubview(bgView)
        bgView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view)
        }
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTapAction))
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func didTapAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension ShoppingCartViewController {
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .content, height: 512)
    }
    
    override func shouldAnimatePresentingVC() -> Bool {
        return true
    }
    
    override func showDragIndicator() -> Bool {
        return false
    }
    
    override func transitionDuration() -> TimeInterval {
        return 1.2
    }
    
    override func springDamping() -> CGFloat {
        return 1
    }
    
}
