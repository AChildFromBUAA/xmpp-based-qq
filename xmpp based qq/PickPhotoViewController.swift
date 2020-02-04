//
//  PickPhotoViewController.swift
//  xmpp based qq
//
//  Created by kyz on 2017/5/17.
//  Copyright © 2017年 BUAA.Software. All rights reserved.
//

import UIKit

class PickPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var image: UIImage?
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBAction func registe(_ sender: UIButton) {
        XmppUser.defaultUser.isLogin = true
        let card = XmppManager.defaultManager.xmppvCard?.myvCardTemp
        if UIImagePNGRepresentation(self.image!) == nil {
            card?.photo = UIImageJPEGRepresentation(self.resize(image: self.image!, to: CGSize(width: 100, height: 100)), 1.0)
        } else {
            card?.photo = UIImagePNGRepresentation(self.resize(image: self.image!, to: CGSize(width: 100, height: 100)))
        }
        XmppManager.defaultManager.xmppvCard?.updateMyvCardTemp(card)
        XmppManager.defaultManager.disconnect()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectFromPhotos = UIAlertAction(title: "从相册选择", style: .destructive){(action) -> Void in
            self.selectFrom(.photoLibrary)
        }
        alertController.addAction(selectFromPhotos)
        let selectFromCamera = UIAlertAction(title: "拍照", style: .destructive){(action) -> Void in
            self.selectFrom(.camera)
        }
        alertController.addAction(selectFromCamera)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectFrom(_ type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if type == .camera {
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                let alertController = UIAlertController(title: "ERROR", message: "无法打开相机", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        self.showDetailViewController(imagePicker, sender: nil)
        
    }

    func resize(image: UIImage, to size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
    }
    
    // MARK: - ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type = info[UIImagePickerControllerMediaType] as! String
        if type == "public.image" {
            let img = info[UIImagePickerControllerEditedImage] as! UIImage
            self.image = img
            self.photoImage.image = self.image
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
