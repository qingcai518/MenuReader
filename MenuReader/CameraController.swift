//
//  CameraController.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/04.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class CameraController: ViewController {
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var albumBtn: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    var imagePicker: UIImagePickerController!
    var takedPicture: UIImage!
    
    @IBAction func doClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doFlash() {
        if (imagePicker == nil) {return}
        if (imagePicker.cameraFlashMode == .auto) {
            imagePicker.cameraFlashMode = .off
        } else if (imagePicker.cameraFlashMode == .off) {
            imagePicker.cameraFlashMode = .on
        } else if (imagePicker.cameraFlashMode == .on) {
            imagePicker.cameraFlashMode = .auto
        }
    }
    
    @IBAction func doSwitch() {
        if (imagePicker == nil) {return}
        if (imagePicker.cameraDevice == .front) {
            imagePicker.cameraDevice = .rear
        } else {
            imagePicker.cameraDevice = .front
        }
    }
    
    @IBAction func doCamera() {
        if (imagePicker == nil) {return}
        imagePicker.takePicture()
    }
    
    @IBAction func doAlbum() {
        let next = PhotoController()
        self.present(next, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createPicker()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createPicker() {
        imagePicker = UIImagePickerController()
        imagePicker.view.frame = CGRect(x: 0, y: 0, width: cameraView.frame.width, height: cameraView.frame.height)
        imagePicker.sourceType = .photoLibrary
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            imagePicker.showsCameraControls = false
        }
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        cameraView.addSubview(imagePicker.view)
        
        setFlashButton()
    }
    
    private func setFlashButton() {
        if (imagePicker.cameraFlashMode == .auto) {
            flashBtn.setImage(UIImage(named: "flash_auto"), for: .normal)
        } else if (imagePicker.cameraFlashMode == .on) {
            flashBtn.setImage(UIImage(named: "flash_on"), for: .normal)
        } else {
            flashBtn.setImage(UIImage(named: "flash_off"), for: .normal)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToResult") {

            print("taked picture = \(takedPicture)")
            print("next = \(next)")
            
            
            guard let next = segue.destination as? ResultController else {return}
            next.image = takedPicture
        }
    }
}

extension CameraController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let picture = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        self.takedPicture = picture
        performSegue(withIdentifier: "ToResult", sender: nil)
    }
}
