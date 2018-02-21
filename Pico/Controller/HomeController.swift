//
//  HomeController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

/*
 Toggle on/off accounts for scan
 Able to scan user multiple times to update permissions
 Add more icons like LinkedIn, Email
 Make it so that if icon is generic, you can still see the platform name
 Full platform integration
 Add Bio
 Editable accounts
 Profile distortion fix
 Check for valid account name
 Invalid QR Code Alert
 FB Realtime DB Integration
 Transfer site end to pico.robertfrankzhang subdomain
 Default Accounts in beginning that are blank, and have it so if not added username, by default toggled off
 */

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
        collectionView?.backgroundColor = ThemeColors.LIGHT_GREEN_MAIN
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
        video.frame = view.frame//view.layer.bounds
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
                                let alertSuccess = UIAlertController(title: "Success", message: "User \(currentUserExists.firstName) was successfully added!", preferredStyle: .alert)
                                alertSuccess.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {(nil) in
                                    self.session.startRunning()
                                }))
                                alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {(nil) in
                                    DB.addUser(user: currentUserExists)
                                    self.session.startRunning()
                                    var validAccounts:[String] = []
                                    for account in currentUserExists.accounts{
                                        if account.toggled{
                                            validAccounts.append(account.accountKey)
                                        }
                                    }
                                    myCache.currentCache.scanned.append(ScannedUser(userID: currentUserExists.userID, accountKeys: validAccounts))
                                    DB.addUser(user: currentUserExists)
                                    self.present(alertSuccess,animated:true,completion: nil)
                                    
                                }))
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
    var qrButton = UIButton()
    
    func setupNavigationBarItems(){
        var calendarLabel = UILabel()
        calendarLabel.text = "Scan QR"
        calendarLabel.textColor = .white
        calendarLabel.font = UIFont.boldSystemFont(ofSize: 25)
        navigationItem.titleView = calendarLabel
        
        var fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20.0
        
        var fixedSpace2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace2.width = 30.0
        
        let signOutButton = UIButton(type: .system)
        signOutButton.setImage(#imageLiteral(resourceName: "signOut").withRenderingMode(.alwaysOriginal), for: .normal)
        signOutButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        qrButton = UIButton(type: .system)
        qrButton.setImage(#imageLiteral(resourceName: "qr").withRenderingMode(.alwaysOriginal), for: .normal)
        qrButton.imageView?.contentMode = .scaleAspectFill
        qrButton.translatesAutoresizingMaskIntoConstraints = false
        qrButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        qrButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        qrButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        qrButton.addTarget(self, action: #selector(viewQR), for: .touchUpInside)
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView:signOutButton),fixedSpace2,UIBarButtonItem(customView:qrButton)]
        
        
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
        
        friendsListButton = UIButton(type: .system)
        friendsListButton.setImage(#imageLiteral(resourceName: "friendsList").withRenderingMode(.alwaysOriginal), for: .normal)
        friendsListButton.imageView?.contentMode = .scaleAspectFill
        friendsListButton.translatesAutoresizingMaskIntoConstraints = false
        friendsListButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        friendsListButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        friendsListButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        friendsListButton.addTarget(self, action: #selector(viewFriends), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView:userProfileButton),fixedSpace,UIBarButtonItem(customView:friendsListButton)]
        
        navigationController?.navigationBar.barTintColor = ThemeColors.navigationBar
        let bounds = self.navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height*1.5)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func viewQR(){
        let qrController = QRController()
        present(UINavigationController(rootViewController: qrController),animated:true,completion: nil)
    }
    
    func viewFriends(){
        let friendsController = FriendsController()
        present(UINavigationController(rootViewController: friendsController),animated:true,completion: nil)
    }
    
    func viewProfile(){
        let profileController = ProfileController()
        present(UINavigationController(rootViewController: profileController),animated:true,completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil){
            print("no user")
            perform(#selector(signOut), with: nil, afterDelay: 0)
        }else{
            var currentUser:Cache? = Cache()
            print("uid"+(DB.getCurrentUserID())!)
            DB.getUser(userID: DB.getCurrentUserID()!, completionHandler: { (user:Cache?) in
                //code called after data loaded
                print("cache received")
                currentUser = user
                if let currentUserExists = currentUser{
                    myCache.currentCache = currentUserExists
                    self.userProfileButton.setImage(myCache.currentCache.profilePic.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:self.userProfileButton)
                    print(myCache.currentCache.userID)
                    print(myCache.currentCache.scanned)
                }else{
                    print("networkerror")
                    //Some Network Error
                }
                //
            })
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

