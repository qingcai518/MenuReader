//
//  TranslateCell.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/04.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class TranslateCell: UITableViewCell {
    @IBOutlet weak var contentLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLbl.text = nil
    }
}
