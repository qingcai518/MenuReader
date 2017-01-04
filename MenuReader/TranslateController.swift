//
//  TranslateController.swift
//  MenuReader
//
//  Created by RN-079 on 2016/12/22.
//  Copyright © 2016年 RN-079. All rights reserved.
//

import UIKit

class TranslateController: ViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var text = ""
    var language = Language.ChineseSimplified
    
    let model = TranslateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        translate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func translate() {
        indicator.startAnimating()
        
        model.doTranslate(source: text, language: language) { [weak self] msg in
            self?.indicator.stopAnimating()
            if let errorMsg = msg {return print("error = \(errorMsg)")}
            self?.tableView.reloadData()
        }
    }
}

extension TranslateController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
        let result = info.target.asObservable()
        result.subscribe(onNext: { value in
            cell.contentLbl.text = value
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
        return cell
    }
}
