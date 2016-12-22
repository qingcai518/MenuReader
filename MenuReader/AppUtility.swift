//
//  AppUtility.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/22.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import Foundation

class AppUtility {
    
    static func getGoogleVisionUrl() -> URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    static func getGoogleTranslateUrl(target: String, q: String) -> String {
        return "https://www.googleapis.com/language/translate/v2?key=\(googleAPIKey)&target=\(target)&q=\(q)"
    }
}
