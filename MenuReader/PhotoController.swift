//
//  PhotoController.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/05.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class PhotoController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setView() {
        self.view.frame  = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.sourceType = .photoLibrary
        self.delegate = self
    }
}

extension PhotoController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        let storyboard = UIStoryboard(name: "Result", bundle: nil)
        guard let next = storyboard.instantiateInitialViewController() as? ResultController else {return}
        next.image = image
        self.pushViewController(next, animated: true)
    }
}
