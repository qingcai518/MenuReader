//
//  TranslateInfo.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/04.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import RxSwift

class TranslateInfo {
    var source: String
    var target = Variable("")
    
    init(source: String) {
        self.source = source
    }
}
