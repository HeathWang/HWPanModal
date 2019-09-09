//
//  InputTableViewCell.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class InputTableViewCell: UITableViewCell {
    
    let textField = UITextField(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.borderStyle = .bezel
        textField.delegate = self
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.width.equalTo(300)
            maker.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
