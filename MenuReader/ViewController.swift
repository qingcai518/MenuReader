//
//  ViewController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/22.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
