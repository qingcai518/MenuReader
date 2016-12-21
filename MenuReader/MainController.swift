//
//  ViewController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/20.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainController: UIViewController {
    @IBOutlet weak var cameraBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func toResultPage(image: UIImage) {
        let storyboard = UIStoryboard(name: "Result", bundle: nil)
        guard let navigation = storyboard.instantiateInitialViewController() as? UINavigationController else {return}
        guard let result = navigation.viewControllers.first as? ResultController else {return}
        result.image = image
        present(navigation, animated: true, completion: nil)
    }
}

extension MainController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        dismiss(animated: true, completion: nil)
        toResultPage(image: image)
    }
}

extension MainController: UINavigationControllerDelegate {
    
}
