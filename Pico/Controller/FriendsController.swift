//
//  FriendsController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import Foundation
import LBTAComponents
import UIKit

class FriendsController: DatasourceController {
    
    static var own = FriendsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = ThemeColors.GRAY
        collectionView?.showsVerticalScrollIndicator = false
        setupNavigationBarItems()
        collectionView?.allowsMultipleSelection = true
        self.datasource = FriendsDatasource()
        FriendsController.own = self
    }
    
    var userProfileButton = UIButton()
    
    func setupNavigationBarItems(){
        var calendarLabel = UILabel()
        calendarLabel.text = "Recently Added"
        calendarLabel.textColor = .white
        calendarLabel.font = UIFont.boldSystemFont(ofSize: 25)
        navigationItem.titleView = calendarLabel
        
        let backButton = UIButton(type: .system)
        backButton.setImage(#imageLiteral(resourceName: "x").withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backButton)
        
        navigationController?.navigationBar.barTintColor = ThemeColors.LIGHT_GREEN_MAIN
        let bounds = self.navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height*1.5)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:view.frame.width,height:80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}



