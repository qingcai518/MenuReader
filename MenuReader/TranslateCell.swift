//
//  TranslateCell.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/05.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class TranslateCell: UITableViewCell {
    @IBOutlet weak var sourceLbl: UILabel!
    @IBOutlet weak var targetLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLbl.text = nil
        targetLbl.text = nil
    }
}
