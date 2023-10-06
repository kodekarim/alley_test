//
//  ViewFromNib.swift
//  alley-test
//
//  Created by abdul karim on 04/10/23.
//

import Foundation

import UIKit

protocol ViewFromNib {}

extension ViewFromNib {
    
    static var nibName:String {
        return String(describing: Self.self)
    }
    
    static var nib:UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
    
    static func registerTableviewCellOn(_ tableview:UITableView) {
        tableview.register(nib, forCellReuseIdentifier: nibName)
    }
    
    static func registerCellForCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
}
