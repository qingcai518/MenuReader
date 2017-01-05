//
//  ResultInfo.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/05.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import RxSwift

class ResultInfo {
    var result: String
    var isSelected = Variable(false)
    
    init(result: String) {
        self.result = result
    }
}
