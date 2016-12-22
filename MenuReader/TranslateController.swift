//
//  TranslateController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/22.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit

class TranslateController: ViewController {
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
        model.doTranslate(source: text, language: language)
    }
}

extension TranslateController: TranslateModelDelegate {
    func failed(error: NSError) {
        print("error = \(error.localizedDescription)")
    }
    
    func complete(result: String?) {
        print("result = \(result)")
    }
}
