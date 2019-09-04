//
//  CustomPresentingController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 wangcongling. All rights reserved.
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
    
}

extension MyCustomAnimationViewController {
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .topInset, height: 84)
    }
    
    override func topOffset() -> CGFloat {
        return 0
    }
    
    override func shouldAnimatePresentingVC() -> Bool {
        return true
    }
    
    override func customPresentingVCAnimation() -> PanModalPresentingViewControllerAnimatedTransitioning? {
        return customAnimation
    }
    
    override func panModalGestureRecognizer(_ panGestureRecognizer: UIPanGestureRecognizer, dismissPercent percent: CGFloat) {
        let scale = 0.9 + percent * 0.1
        presentingViewController?.view.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}

fileprivate class MyCustomAnimation: NSObject, PanModalPresentingViewControllerAnimatedTransitioning {
    
    func presentTransition(context transitionContext: PanModalPresentingViewControllerContextTransitioning) {
        let duration = transitionContext.mainTransitionDuration()
        let VC = transitionContext.viewController(forKey: .from)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            VC?.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    func dismissTransition(context transitionContext: PanModalPresentingViewControllerContextTransitioning) {
        let duration = transitionContext.mainTransitionDuration()
        let VC = transitionContext.viewController(forKey: .to)
        UIView.animate(withDuration: duration) {
            VC?.view.transform = CGAffineTransform.identity
        }
    }
    
}
