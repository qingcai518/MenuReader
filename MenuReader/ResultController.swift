//
//  ResultController.swift
//  MenuReader
//
//  Created by RN-079 on 2017/01/04.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import UIKit
import RxSwift

class ResultController: ViewController {
    @IBOutlet weak var tableView1 : UITableView!
    @IBOutlet weak var tableView2 : UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    let model = ResultModel()
    var results = [String]()
    
    // params.
    var image : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        
        // データを取得する.
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getData() {
        indicator.startAnimating()
        model.createRequest(image: image)
    }
    
    private func setTableView() {
        tableView1.tableFooterView = UIView()
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.tableFooterView = UIView()
        tableView2.delegate = self
        tableView2.dataSource = self
        
        model.delegate = self
    }
}

extension ResultController : ResultModelDelegate {
    func complete(result: String?) {
        indicator.stopAnimating()
        guard let contentArray = result?.components(separatedBy: "\n") else {return}
        
        for content in contentArray {
            if (content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "") {
                continue
            }
            
            results.append(content)
        }
        
        print("results = \(results)")
        
        tableView1.reloadData()
    }
    
    func failed(error: NSError) {
        indicator.stopAnimating()
        print("error = \(error.localizedDescription)")
    }
}

extension ResultController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView === tableView1) {
            return 44
        } else {
            let width = screenWidth - 2 * 12
            let height = (width / image.size.width ) * image.size.height
            
            return height + 12
        }
    }
}

extension ResultController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView === tableView1) {
            return results.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableView1) {
            let info = results[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
            cell.resultTf.text = info
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.pictureView.image = self.image
            return cell
        }
    }
}
