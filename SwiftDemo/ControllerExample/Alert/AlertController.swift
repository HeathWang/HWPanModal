//
//  AlertController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/8/28.
//  Copyright © 2019 heath wang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import HWPanModal

class AlertController: UIViewController {

    lazy var alertView: AlertView = {
        let alertView = AlertView(frame: .zero)
        alertView.layer.cornerRadius = 8
        return alertView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(alertView)

        alertView.snp.makeConstraints { maker in
            maker.left.equalTo(40)
            maker.right.equalTo(-40)
            maker.top.equalTo(0)
            maker.height.equalTo(alertContentHeight)
        }
    }
}

extension AlertController {
     override func shortFormHeight() -> PanModalHeight {
        return PanModalHeightMake(.content, alertContentHeight)
    }

    override func longFormHeight() -> PanModalHeight {
        return self.shortFormHeight()
    }

    override func backgroundAlpha() -> CGFloat {
        return 0.1
    }

    override func shouldRoundTopCorners() -> Bool {
        return false
    }

    override func anchorModalToLongForm() -> Bool {
        return false
    }
    
    override func showDragIndicator() -> Bool {
        return true
    }
}

class TransientAlertController: AlertController {

    private weak var timer: Timer?
    private var countDown = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.countDown -= 1
            self?.updateUI()
        }
        
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    @objc func updateUI() {
        guard countDown > 0 else {
            invalidateTimer()
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
    
}

extension TransientAlertController {
    override func backgroundAlpha() -> CGFloat {
        return 0
    }

    override func showDragIndicator() -> Bool {
        return false
    }

    override func isUserInteractionEnabled() -> Bool {
        return false
    }
}

let alertContentHeight: CGFloat = 60

class AlertView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(displayP3Red: 0.972, green: 0.969, blue: 0.836, alpha: 1)
        let label = UILabel()
        label.text = "THIS IS AN ERROR!"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.red
        label.textAlignment = .center

        self.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
