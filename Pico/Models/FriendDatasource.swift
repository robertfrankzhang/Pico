//
//  FriendDatasource.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents

class FriendDatasource:Datasource{
    override func headerClasses() -> [DatasourceCell.Type]? {
        return []
    }
    override func footerClasses() -> [DatasourceCell.Type]? {
        return []
    }
    override func cellClasses() -> [DatasourceCell.Type] {
        return [FriendView.self,FriendAccountCell.self]
    }
    override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == 0{
            return ""
        }else{
            var filteredAccounts:[Account] = []
            
            var checkAccount = ScannedUser()
            for s in myCache.currentCache.scanned{
                if s.userID == UserViewController.user.userID{
                    checkAccount = s
                }
            }
            for account in UserViewController.user.accounts{
                for scan in checkAccount.accountKeys{
                    if account.accountKey == scan{
                        filteredAccounts.append(account)
                    }
                }
            }
            return filteredAccounts[indexPath.item]
        }
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        
        if section == 0{
            return 1
        }else{
            var filteredAccounts:[Account] = []
            
            var checkAccount = ScannedUser()
            for s in myCache.currentCache.scanned{
                if s.userID == UserViewController.user.userID{
                    checkAccount = s
                }
            }
            for account in UserViewController.user.accounts{
                for scan in checkAccount.accountKeys{
                    if account.accountKey == scan{
                        filteredAccounts.append(account)
                    }
                }
            }
            return filteredAccounts.count
        }
    }
    
    override func numberOfSections() -> Int {
        return 2
    }
}
