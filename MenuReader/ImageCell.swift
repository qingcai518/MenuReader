//
//  ImageCell.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/04.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    @IBOutlet weak var pictureView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureView.image = nil
    }
}
