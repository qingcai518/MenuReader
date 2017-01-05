//
//  ViewController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/20.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainController: ViewController {
    @IBOutlet weak var cameraBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openCamera() {
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        guard let next = storyboard.instantiateInitialViewController() else {return}
        present(next, animated: true, completion: nil)
    }
}
