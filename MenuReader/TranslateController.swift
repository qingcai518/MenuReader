//
//  TranslateController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/22.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit

class TranslateController: ViewController {
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var text = ""
    var language = Language.ChineseSimplified
    
    let model = TranslateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func translate() {
        indicator.startAnimating()
        
        model.doTranslate(source: text, language: language) { [weak self] result, errorMsg in
            self?.indicator.stopAnimating()
            
            if let msg = errorMsg {
                print("error = \(msg)")
                return
            }
            
            guard let translatedText = result else {
                print("error occours.")
                return
            }
            
            self?.resultLbl.text = translatedText
        }
    }
}
