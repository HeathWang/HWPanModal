//
//  ColorBlockController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

class ColorBlocksViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 20) / 2, height: 88)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.register(ColorCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ColorCollectionCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    lazy var colors: [UIColor] = {
        var colors: [UIColor] = []
        for _ in 1...20 {
            colors.append(.random())
        }
        return colors
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtonItem = UIBarButtonItem(title: "Present", style: .plain, target: self, action: #selector(onTapToPresent))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view)
        }
    }
    
    @objc func onTapToPresent() {
        presentPanModal(BlurViewController())
    }
    
}

extension ColorBlocksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ColorCollectionCell.self), for: indexPath) as? ColorCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.bgColor = colors[indexPath.row]
        
        return cell
    }
    
}

class ColorCollectionCell: UICollectionViewCell {
    
    fileprivate var bgColor: UIColor = .white {
        willSet {
            contentView.backgroundColor = newValue
        }
    }
    
}
