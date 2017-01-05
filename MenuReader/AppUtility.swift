//
//  AppUtility.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/22.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import Foundation
import UIKit

class AppUtility {
    
    static func getGoogleVisionUrl() -> URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    static func getGoogleTranslateUrl(target: String, q: String) -> String {
        return "https://www.googleapis.com/language/translate/v2?key=\(googleAPIKey)&target=\(target)&q=\(q)"
    }
    
    static func getTextHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        
        let textRect = attributedText.boundingRect(with: CGSize(width: width, height: 2000), options: .usesLineFragmentOrigin, context: nil)
        let height = textRect.height
        return height
    }
}
