//
//  CustomPresentingController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

class MyCustomAnimationViewController: UIViewController {
    
    fileprivate let customAnimation = MyCustomAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 0.600, green: 1.000, blue: 0.600, alpha: 1)
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
}

extension MyCustomAnimationViewController {
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .topInset, height: 84)
    }
    
    override func topOffset() -> CGFloat {
        return 0
    }
    
    override func presentingVCAnimationStyle() -> PresentingViewControllerAnimationStyle {
        return .custom
    }
    
    override func customPresentingVCAnimation() -> PanModalPresentingViewControllerAnimatedTransitioning? {
        return customAnimation
    }
    
}

fileprivate class MyCustomAnimation: NSObject, PanModalPresentingViewControllerAnimatedTransitioning {
    
    func presentTransition(context transitionContext: PanModalPresentingViewControllerContextTransitioning) {
        let duration = transitionContext.transitionDuration()
        let VC = transitionContext.viewController(forKey: .from)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            VC?.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    func dismissTransition(context transitionContext: PanModalPresentingViewControllerContextTransitioning) {
        let VC = transitionContext.viewController(forKey: .to)
        VC?.view.transform = CGAffineTransform.identity
    }
    
}
