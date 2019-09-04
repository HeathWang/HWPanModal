//
//  DemoType.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/8/28.
//  Copyright © 2019 heath wang. All rights reserved.
//

import Foundation
import UIKit

protocol DemoRowInfo {
    var string: String { get }
    var rowVC: UIViewController { get }
    var action: Action { get }
}

extension DemoRowInfo {
    
    var action: Action {
        return .present
    }
}

enum DemoList {
    case home
    case app
}

enum Action {
    case push, present
}

struct DemoCell: DemoRowInfo {
    var string: String
    var rowVC: UIViewController
    var action: Action

    init(string: String, rowVC: UIViewController, action: Action = .present) {
        self.string = string
        self.rowVC = rowVC
        self.action = action
    }

    static func homeDemoCells() -> [DemoCell] {
        let vc = ViewController()
        vc.demoType = .app
        let app = DemoCell(string: "App Demo", rowVC: vc, action: .push)
        let blur = DemoCell(string: "Blur Background", rowVC: BasicViewController(), action: .push)
        let indicator = DemoCell(string: "Custom Indicator", rowVC: BasicViewController(), action: .push)
        let keyboard = DemoCell(string: "Auto Handle Keyboard", rowVC: BasicViewController())
        let basic = DemoCell(string: "Basic", rowVC: BasicViewController())
        let alert = DemoCell(string: "Alert", rowVC: AlertController())
        let transientAlert = DemoCell(string: "Transient", rowVC: TransientAlertController())
        let dynamicHeight = DemoCell(string: "Dynamic Height", rowVC: DynamicViewController())
        let group = DemoCell(string: "Group", rowVC: GroupViewController())
        let stackedGroup = DemoCell(string: "Group - Stacked", rowVC: BasicViewController())
        let fullNav = DemoCell(string: "Full Screen - Nav", rowVC: BasicViewController())
        let customPresenting = DemoCell(string: "Custom Presenting Animation", rowVC: BasicViewController())
        return [app, blur, indicator, keyboard, basic, alert, transientAlert, dynamicHeight, group, stackedGroup, fullNav, customPresenting]
    }

    static func appDemoCells() -> [DemoCell] {
        let zhihu = DemoCell(string: "Group - Nav - 知乎评论", rowVC: BasicViewController())
        let picker = DemoCell(string: "Picker", rowVC: BasicViewController())
        let share = DemoCell(string: "Share - 网易云音乐", rowVC: BasicViewController())
        let jd = DemoCell(string: "Shopping - JD", rowVC: BasicViewController())
        return [zhihu, picker, share, jd]
    }
}
