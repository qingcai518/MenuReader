//
//  AppConstants.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/21.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let googleAPIKey = "AIzaSyDHGs7cEZfEMpgGRCNmR4nB5EtgspWyVzg"
var googleURL: URL {
    return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
}
