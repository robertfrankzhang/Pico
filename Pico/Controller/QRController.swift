//
//  QRController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import Foundation
import LBTAComponents
import UIKit

class QRController: DatasourceController {
    
    let QRCode:UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white//ThemeColor.whitish
        collectionView?.showsVerticalScrollIndicator = false
        setupNavigationBarItems()
        collectionView?.allowsMultipleSelection = true
        
        print(myCache.currentCache.userID)
        view.addSubview(QRCode)
        QRCode.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant:view.frame.height/3-view.frame.height/6, leftConstant: view.frame.width/2-view.frame.height/6, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.height/3, heightConstant: view.frame.height/3)
        
        let data = myCache.currentCache.userID.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        let image = filter?.outputImage!
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = image?.applying(transform)
        
        let tImage = UIImage(ciImage: transformImage!)
        QRCode.image = tImage
    }
    
    var userProfileButton = UIButton()
    
    func setupNavigationBarItems(){
        var calendarLabel = UILabel()
        calendarLabel.text = "My QR Code"
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


