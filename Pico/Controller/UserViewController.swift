//
//  UserViewController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import Foundation
import LBTAComponents
import UIKit

class UserViewController: DatasourceController {
    
    var user:Cache
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white//ThemeColor.whitish
        collectionView?.showsVerticalScrollIndicator = false
        setupNavigationBarItems()
        collectionView?.allowsMultipleSelection = true
    }
    
    var userProfileButton = UIButton()
    
    override init(user:Cache) {
        super.init()
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNavigationBarItems(){
        var calendarLabel = UILabel()
        calendarLabel.text = "Profile"
        calendarLabel.textColor = .white//ThemeColor.whitish
        calendarLabel.font = UIFont.boldSystemFont(ofSize: 25)
        navigationItem.titleView = calendarLabel
        
        let backButton = UIButton(type: .system)
        backButton.setImage(#imageLiteral(resourceName: "x").withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backButton)
        
        navigationController?.navigationBar.barTintColor = .red//ThemeColor.red
        let bounds = self.navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height*1.5)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
