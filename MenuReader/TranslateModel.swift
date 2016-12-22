//
//  TranslateModel.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/22.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import Foundation
import Alamofire

protocol TranslateModelDelegate {
    func complete(result: String?)
    func failed(error: NSError)
}


class TranslateModel {
    var delegate : TranslateModelDelegate!
    
    func doTranslate(source: String, language: Language) {
        let url = "https://www.googleapis.com/language/translate/v2"
        let params = ["key":googleAPIKey, "target":language.rawValue, "q":source]

        let headers:HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? ""
        ]
        
        Alamofire.request(url, parameters: params, headers: headers).responseJSON { [unowned self] response in
            if let error = response.result.error {
                return self.delegate.failed(error: error as NSError)
            }
            
            guard let result = response.result.value as? NSDictionary else {
                return self.delegate.failed(error: NSError(domain: "fail to get result.", code: 1005, userInfo: nil))
            }
            
            guard let data = result["data"] as? NSDictionary else {
                 return self.delegate.failed(error: NSError(domain: "fail to get data.", code: 1005, userInfo: nil))
            }
            
            if let translations = data["translations"] as? NSDictionary {
                guard let translatedText = translations["translatedText"] as? String else {
                    return self.delegate.complete(result: "")
                }
                
                return self.delegate.complete(result: translatedText)
            } else {
                return self.delegate.complete(result: "")
            }
        }
    }
}
