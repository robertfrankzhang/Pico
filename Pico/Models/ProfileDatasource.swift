//
//  ProfileDatasource.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents

class ProfileDatasource:Datasource{
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [AddAccountHeader.self,AddAccountHeader.self]
    }
    override func footerClasses() -> [DatasourceCell.Type]? {
        return []
    }
    override func cellClasses() -> [DatasourceCell.Type] {
        return [ProfileView.self,AccountCell.self]
    }
    override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == 0{
            return myCache.currentCache.profilePic
        }else{
            return myCache.currentCache.accounts[indexPath.item]
        }
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return myCache.currentCache.accounts.count
        }
    }
    
    override func numberOfSections() -> Int {
        return 2
    }
}
