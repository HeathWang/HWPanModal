//
//  MyNavigationController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

class MyNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchDataVC = FetchDataViewController()
        pushViewController(fetchDataVC, animated: false)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        self.panModalSetNeedsLayoutUpdate()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        self.panModalSetNeedsLayoutUpdate()
        return vc
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let vcs = super.popToRootViewController(animated: animated)
        self.panModalSetNeedsLayoutUpdate()
        return vcs
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let vcs = super.popToViewController(viewController, animated: animated)
        self.panModalSetNeedsLayoutUpdate()
        return vcs
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
}

extension MyNavigationViewController {
    
    override func panScrollable() -> UIScrollView? {
        let VC = topViewController!
        if VC.conforms(to: HWPanModalPresentable.self) {
            return (VC as HWPanModalPresentable).panScrollable()
        }
        return nil
    }
    
    override func topOffset() -> CGFloat {
        return 0
    }
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .topInset, height: UIApplication.shared.statusBarFrame.height + 20)
    }
    
    override func allowScreenEdgeInteractive() -> Bool {
        return true
    }
    
    override func showDragIndicator() -> Bool {
        return false
    }
    
    override func presentingVCAnimationStyle() -> PresentingViewControllerAnimationStyle {
        return .pageSheet
    }
}

class UserGroupViewController: GroupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "COLOR LIST"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = colors[indexPath.row]
        let detailVC = GroupDetailViewController(detailColor: color)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
