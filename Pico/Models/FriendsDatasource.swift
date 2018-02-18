//
//  FriendsDatasource.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents

class FriendsDatasource:Datasource{
    override func headerClasses() -> [DatasourceCell.Type]? {
        return []
    }
    override func footerClasses() -> [DatasourceCell.Type]? {
        return []
    }
    override func cellClasses() -> [DatasourceCell.Type] {
        return [FriendCell.self]
    }
    override func item(_ indexPath: IndexPath) -> Any? {
        return myCache.currentCache.scanned[indexPath.item]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return myCache.currentCache.scanned.count
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
}
