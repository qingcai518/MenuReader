//
//  TranslateController.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/05.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit

class TranslateController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // 通訳前の文字列の配列.
    var sources = [String]()
    
    let model = TranslateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        model.doTranslate(sources: sources, language: .ChineseSimplified) { [weak self] msg in
            if let errorMsg = msg {print("error = \(errorMsg)")}
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TranslateController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = model.translateInfos[indexPath.row]
        let sourceHeight = AppUtility.getTextHeight(text: info.source, width: screenWidth - 2 * 12, font: UIFont.Helvetica12())
        let targetHeight = AppUtility.getTextHeight(text: info.target.value, width: screenWidth - 52, font: UIFont.Helvetica14())
        
        return 12 + sourceHeight + 12 + targetHeight + 12 + 20
    }
}

extension TranslateController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.translateInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = model.translateInfos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslateCell", for: indexPath) as! TranslateCell
        cell.sourceLbl.text = info.source
        cell.targetLbl.text = info.target.value
        
        return cell
    }
}
