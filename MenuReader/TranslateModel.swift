//
//  TranslateModel.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/22.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import Foundation
import Alamofire


class TranslateModel {
    func doTranslate(source: String, language: Language, completion: @escaping (_ result: String?, _ errorMsg: String?) -> Void) {
        let url = "https://www.googleapis.com/language/translate/v2"
        let params = ["key":googleAPIKey, "target":language.rawValue, "q":source]

        let headers:HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? ""
        ]
        
        Alamofire.request(url, parameters: params, headers: headers).responseJSON { response in
            if let error = response.result.error {
                return completion(nil, error.localizedDescription)
            }
            
            guard let result = response.result.value as? NSDictionary else {
                return completion(nil, "fail to get result.")
            }
            
            guard let data = result["data"] as? NSDictionary else {
                return completion(nil, "fail to get data.")
            }
            
            if let translations = data["translations"] as? NSArray {
                guard let translation = translations[0] as? NSDictionary else {
                    return completion("", nil)
                }
                guard let translatedText = translation["translatedText"] as? String else {
                    return completion("", nil)
                }
                
                return completion(translatedText, nil)
            } else {
                print("data[translations] = \(data["translations"])")
                return completion("", nil)
            }
        }
    }
}
