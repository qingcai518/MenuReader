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
    var translateInfos = [TranslateInfo]()
    
    func doTranslate(sources: [String], language: Language, completion: @escaping (_ msg: String?) -> Void) {
        let url = "https://www.googleapis.com/language/translate/v2"
        for source in sources {
            let info = TranslateInfo(source: source)
            translateInfos.append(info)
        }
        
        for info in translateInfos {
            let params = ["key":googleAPIKey, "target":language.rawValue, "q":info.source]
            
            let headers:HTTPHeaders = [
                "Content-Type": "application/json",
                "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? ""
            ]
            
            Alamofire.request(url, parameters: params, headers: headers).responseJSON { response in
                if let error = response.result.error {
                    return completion(error.localizedDescription)
                }
                
                guard let result = response.result.value as? NSDictionary else {
                    return completion("fail to get result from response.")
                }
                
                guard let data = result["data"] as? NSDictionary else {
                    return completion("fail to get data from result.")
                }
                
                guard let translations = data["translations"] as? NSArray else {
                    return completion("fail to get translations from data.")
                }
                
                guard let translation = translations[0] as? NSDictionary else {
                    return completion("fail to get translation from translations.")
                }
                
                guard let translatedText = translation["translatedText"] as? String else {
                    return completion("fail to get text from translation.")
                }
                
                info.target.value = translatedText
                return completion(nil)
            }
        }
    }
}
