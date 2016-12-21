//
//  ResultController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/21.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultController: UIViewController {
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBAction func doClose() {
        dismiss(animated: true, completion: nil)
    }

    let model = ResultModel()
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setView() {
        indicator.startAnimating()
        model.createRequest(image: image)
        model.delegate = self
        
        let width = screenWidth - 2 * 16
        let height = (width / image.size.width) * image.size.height
        let imageView = UIImageView(frame: CGRect(x: 16, y: 16, width: screenWidth - 2 * 16, height: height))
        
        imageView.image = image
        scrollView.addSubview(imageView)
        scrollView.contentSize = CGSize(width: screenWidth - 2 * 16, height: height + 2 * 16)
    }
    
    private func showAlert(msg: String) {
        let controller = UIAlertController(title: "Fail", message: "msg", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        
        present(controller, animated: true, completion: nil)
    }
}

extension ResultController : ResultModelDelegate {
    func failed(error: NSError) {
        indicator.stopAnimating()
        print("error = \(error.domain)")
    }
    
    func complete(result: String?) {
        indicator.stopAnimating()
        resultLbl.text = result
    }
}
