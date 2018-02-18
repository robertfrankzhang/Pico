//
//  ProfileController.swift
//  Pico
//
//  Created by Robert Frank Zhang on 2/18/18.
//  Copyright © 2018 iLaunch. All rights reserved.
//

import Foundation
import LBTAComponents
import UIKit

class ProfileController: DatasourceController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    static var own = ProfileController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = ThemeColors.GRAY
        collectionView?.showsVerticalScrollIndicator = false
        setupNavigationBarItems()
        collectionView?.allowsMultipleSelection = true
        self.datasource = ProfileDatasource()
        ProfileController.own = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
    
    var userProfileButton = UIButton()

    func setupNavigationBarItems(){
        var calendarLabel = UILabel()
        calendarLabel.text = "My Profile"
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
    
   
    static func takePhoto(){
        print("photo")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = own
        
        let actionSheet = UIAlertController(title: "Update Your Profile Picture", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = false
                own.present(imagePickerController, animated: true, completion: nil)
            }else{
                //Camera Not Available
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            own.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction) in
            
        }))
        
        own.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            DB.updateProfilePicture(image: editedImage)
            myCache.currentCache.profilePic = editedImage
            collectionView?.reloadData()
            return
        }
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            DB.updateProfilePicture(image: image)
            myCache.currentCache.profilePic = image
            collectionView?.reloadData()
            return
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width:self.view.frame.width,height:self.view.frame.width/1.5)
        }
        return CGSize(width:view.frame.width,height:80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width:view.frame.width,height:50)
        }
        return CGSize.zero
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


