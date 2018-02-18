//
//  HomeController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
import Firebase
import AVFoundation
import AudioToolbox

class HomeController: DatasourceController, AVCaptureMetadataOutputObjectsDelegate{
    
    var video = AVCaptureVideoPreviewLayer()
    var session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white//ThemeColor.whitish
        collectionView?.showsVerticalScrollIndicator = false
        setupNavigationBarItems()
        collectionView?.allowsMultipleSelection = true
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }catch{
            
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects != nil && metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObjectTypeQRCode{
                    DB.getUser(userID: object.stringValue, completionHandler: {(user:Cache?) in
                        let currentUser = user
                        if let currentUserExists = currentUser{
                            var isJoinedAlready = false
                            for user in myCache.currentCache.scanned{
                                if user.userID == currentUserExists.userID{
                                    isJoinedAlready = true
                                }
                            }
                            if !isJoinedAlready{
                                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                                self.session.stopRunning()
                                
                                let alert = UIAlertController(title: "User Detected", message: "Add \(currentUserExists.firstName)?", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Join", style: .default, handler: {(nil) in
//                                    DatabaseFactory.DB.joinGroup(groupID: currentGroupExists.groupID)
//                                    self.session.startRunning()
//                                    myCache.currentCache.groups.append(currentGroupExists)
//                                    //self.groupJoinSuccess()
//                                }))
//                                alert.addAction(UIAlertAction(title: "View Group", style: .default, handler: {(nil) in
//                                    self.currentDetectedGroup = currentGroupExists
//                                    JoinGroupController.own?.present(UINavigationController(rootViewController: GroupInfoController(group:currentGroupExists)), animated: true, completion: nil)
//                                }))
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(nil) in
                                    self.session.startRunning()
                                }))
                                
                                self.present(alert,animated:true,completion: nil)
                                
                            }
                        }else{
                            print("Not a group")//group not loaded correctly
                        }
                    })
                }
            }
        }
    }
    
    var userProfileButton = UIButton()
    var friendsListButton = UIButton()
    
    func setupNavigationBarItems(){
        var calendarLabel = UILabel()
        calendarLabel.text = "Scan QR"
        calendarLabel.textColor = .white//ThemeColor.whitish
        calendarLabel.font = UIFont.boldSystemFont(ofSize: 25)
        navigationItem.titleView = calendarLabel
        
        let signOutButton = UIButton(type: .system)
        signOutButton.setImage(#imageLiteral(resourceName: "signOut").withRenderingMode(.alwaysOriginal), for: .normal)
        signOutButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:signOutButton)
        
        userProfileButton = UIButton(type: .system)
        userProfileButton.setImage(myCache.currentCache.profilePic.withRenderingMode(.alwaysOriginal), for: .normal)
        userProfileButton.imageView?.contentMode = .scaleAspectFill
        userProfileButton.translatesAutoresizingMaskIntoConstraints = false
        userProfileButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        userProfileButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        userProfileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        userProfileButton.layer.cornerRadius = 12
        userProfileButton.layer.masksToBounds = true
        userProfileButton.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
        
        var fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 15.0
        
        friendsListButton = UIButton(type: .system)
        friendsListButton.setImage(#imageLiteral(resourceName: "friendsList").withRenderingMode(.alwaysOriginal), for: .normal)
        friendsListButton.imageView?.contentMode = .scaleAspectFill
        friendsListButton.translatesAutoresizingMaskIntoConstraints = false
        friendsListButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        friendsListButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        friendsListButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        friendsListButton.addTarget(self, action: #selector(viewFriends), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView:friendsListButton),fixedSpace,UIBarButtonItem(customView:userProfileButton)]
        
        navigationController?.navigationBar.barTintColor = .red//ThemeColor.red
        let bounds = self.navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height*1.5)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func viewFriends(){
        
    }
    
    func viewProfile(){
        let profileController = ProfileController()
        present(UINavigationController(rootViewController: profileController),animated:true,completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil){
            print("no user")
            perform(#selector(signOut), with: nil, afterDelay: 0)
        }
    }
    
    func signOut(){
        let loginController = LoginController()
        //Signout
        do{
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        //
        myCache.currentCache = Cache()
        present(loginController,animated:true,completion: nil)
        print("signed out")
    }
    
}

