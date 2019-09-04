//
//  BasicViewController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/8/28.
//  Copyright © 2019 heath wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

class BasicViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(displayP3Red: 0.000, green: 0.989, blue: 0.935, alpha: 1.00)
    }
}

extension BasicViewController {
    
    override func shortFormHeight() -> PanModalHeight {
        return PanModalHeightMake(.content, 200)
    }
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeightMake(.topInset, 40);
    }
    
    override func transitionAnimationOptions() -> UIView.AnimationOptions {
        return [.curveLinear]
    }
    
}

