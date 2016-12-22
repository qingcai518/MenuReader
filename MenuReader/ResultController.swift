//
//  ResultController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/21.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultController: ViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var translateView: UIView!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var translateBtn: UIButton!
    
    let model = ResultModel()
    var image: UIImage!
    var language = Language.ChineseSimplified
    
    @IBAction func doClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doChange() {
        print("change language.")
    }

    @IBAction func doTranslate() {
        performSegue(withIdentifier: "toTranslate", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTranslate" {
            guard let next = segue.destination as? TranslateController else {return}
            next.text = textView.text
            next.language = language
        }
    }
    
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
        
        // 翻译后的文字
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        
        // 图片
        let width = screenWidth - 2 * 16
        let height = (width / image.size.width) * image.size.height
        let imageView = UIImageView(frame: CGRect(x: 16, y: 0, width: width, height: height))
        
        imageView.image = image
        scrollView.addSubview(imageView)
        scrollView.contentSize = CGSize(width: screenWidth, height: height + 16)
        
        // translate zone.
        translateView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        if let lngStr = UserDefaults.standard.string(forKey: UDKey.Language) {
            if let lng = Language(rawValue: lngStr) {language = lng}
        }
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
        textView.text = result
    }
}
