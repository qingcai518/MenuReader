//
//  ResultCell.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/04.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResultCell: UITableViewCell {
    @IBOutlet weak var resultTf: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resultTf.text = nil
        disposeBag = DisposeBag()
    }
}
