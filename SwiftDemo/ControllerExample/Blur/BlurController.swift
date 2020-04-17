//
//  BlurController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

class BlurViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 0.200, green: 0.400, blue: 1.000, alpha: 1)
    }
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .topInset, height: 150)
    }
    
    override func backgroundConfig() -> HWBackgroundConfig {
        return HWBackgroundConfig(behavior: .customBlurEffect)
    }
    
}
