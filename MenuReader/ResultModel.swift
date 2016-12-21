//
//  ResultModel.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/21.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ResultModelDelegate {
    func complete(result: String?)
    func failed(error: NSError)
}

class ResultModel {
    var delegate : ResultModelDelegate!
    
    func createRequest(image: UIImage) {
        // Create our request URL
        let imageBase64 = base64EncodeImage(image)
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
//                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return delegate.failed(error: NSError(domain: "fail to serialize json.", code: 1001, userInfo: nil))
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async {
            self.runRequestOnBackgroundThread(request)
        }
    }
    
    private func base64EncodeImage(_ image: UIImage) -> String {
        guard var imagedata = UIImagePNGRepresentation(image) else {return ""}
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    private func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    private func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error as? NSError {
                return self.delegate.failed(error: err)
            }
            
            guard let data = data else {
                return self.delegate.failed(error: NSError(domain: "fail to get data.", code: 1002, userInfo: nil))
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
    
    private func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                return self.delegate.failed(error: NSError(domain: "fail to get data from json", code: 1003, userInfo: nil))
            } else {
                let response = json["responses"][0]
                let annocations = response["textAnnotations"]
                
                if annocations == JSON.null {
                    return self.delegate.complete(result: nil)
                }

                let textData = annocations[0]
                let text = textData["description"].string
                
                return self.delegate.complete(result: text)
            }
        })
        
    }
}
