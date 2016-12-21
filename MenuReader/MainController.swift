//
//  ViewController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/20.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit

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
    
    private func setPickerView() {
        
    }
}

extension MainController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

extension MainController: UINavigationControllerDelegate {
    
}
