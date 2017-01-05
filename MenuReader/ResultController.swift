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
    @IBOutlet weak var selectBtn: UIButton!
    
    var bottomView = UIView()
    var translatePartBtn = UIButton()
    var translateAllBtn = UIButton()

    let model = ResultModel()
    let bottomHeight = CGFloat(118)
    var results = [ResultInfo]()
    var sources = [Int: String]()
    
    var isSelectable = Variable(false)
    
    var isTranslateAll = false
    
    // params.
    var image : UIImage!
    
    @IBAction func doSelect() {
        isSelectable.value = !isSelectable.value
        if (!isSelectable.value) {
            for result in results {
                result.isSelected.value = false
            }
            
            hideBottomView()
        } else {
            // 選択ボタンが押下されたら、sourcesの内容をクリアする.
            sources.removeAll()
            showBottomView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setBottomView()
        
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
    
    private func setBottomView() {
        bottomView.frame = CGRect(x: 0, y : screenHeight, width: screenWidth, height : bottomHeight)
        bottomView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        self.view.addSubview(bottomView)
        
        translatePartBtn.frame = CGRect(x: 30, y: 12, width: screenWidth - 2 * 30, height: 40)
        translatePartBtn.rx.tap.asObservable().bindNext { [weak self] in
            self?.isTranslateAll = false
            self?.performSegue(withIdentifier: "ToTranslate", sender: nil)
        }.addDisposableTo(disposeBag)
        translatePartBtn.setBackgroundImage(UIImage(named: "btn_light_blue"), for: .normal)
        translatePartBtn.setTitle("選択したレコードを翻訳", for: .normal)
        translatePartBtn.setTitleColor(UIColor.white, for: .normal)
        translatePartBtn.titleLabel?.font = UIFont.HelveticaBold16()
        translatePartBtn.isEnabled = false
        bottomView.addSubview(translatePartBtn)
        
        translateAllBtn.frame = CGRect(x: 30, y: 64, width: screenWidth - 2 * 30, height: 40)
        translateAllBtn.rx.tap.asObservable().bindNext { [unowned self] in
            self.isTranslateAll = true
            self.performSegue(withIdentifier: "ToTranslate", sender: nil)
        }.addDisposableTo(disposeBag)
        translateAllBtn.setBackgroundImage(UIImage(named: "btn_light_blue"), for: .normal)
        translateAllBtn.setTitle("全件翻訳", for: .normal)
        translateAllBtn.setTitleColor(UIColor.white, for: .normal)
        translateAllBtn.titleLabel?.font = UIFont.HelveticaBold16()
        bottomView.addSubview(translateAllBtn)
    }
    
    func showBottomView() {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.bottomView.frame = CGRect(x: 0, y: screenHeight - self.bottomHeight, width: screenWidth, height: self.bottomHeight)
        }) { isFinished in
        }
    }
    
    func hideBottomView() {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.bottomView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: self.bottomHeight)
        }) { isFinished in
        }
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
            
            let info = ResultInfo(result: content)
            results.append(info)
        }
        
        print("results = \(results)")
        tableView1.reloadData()
    }
    
    func failed(error: NSError) {
        indicator.stopAnimating()
        print("error = \(error.localizedDescription)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToTranslate") {
            guard let next = segue.destination as? TranslateController else {return}
            
            if (isTranslateAll) {
                for result in results {
                    next.sources.append(result.result)
                }
            } else {
                for (_, value) in sources {
                    next.sources.append(value)
                }
             }
        }
    }
}

extension ResultController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (tableView === tableView1) {
            let info = results[indexPath.row]
            
            if (isSelectable.value) {
                info.isSelected.value = !info.isSelected.value
                if (info.isSelected.value) {
                    sources[indexPath.row] = info.result
                } else {
                    sources.removeValue(forKey: indexPath.row)
                }
                
                
                var flag = false
                for result in results {
                    if (result.isSelected.value) {
                        flag = true
                        break
                    }
                }
                self.translatePartBtn.isEnabled = flag
                
            } else {
                isTranslateAll = false
                let info = results[indexPath.row]
                sources.removeAll()
                sources[indexPath.row] = info.result
                performSegue(withIdentifier: "ToTranslate", sender: nil)
            }
        }
    }
    
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
            cell.resultTf.text = info.result
            cell.editBtn.rx.tap.asObservable().bindNext { [weak self] in
                if (cell.editBtn.currentImage == UIImage(named: "ok_green")) {
                    cell.editBtn.setImage(UIImage(named: "edit"), for: .normal)
                    self?.results[indexPath.row].result = cell.resultTf.text!
                    cell.resultTf.isEnabled = false
                } else {
                    cell.editBtn.setImage(UIImage(named: "ok_green"), for: .normal)
                    cell.resultTf.isEnabled = true
                    cell.resultTf.becomeFirstResponder()
                }
            }.addDisposableTo(cell.disposeBag)
            
            info.isSelected.asDriver().drive(onNext: { value in
                cell.checkboxView.image = value ? UIImage(named: "checkbox") : UIImage(named: "checkbox_uncheck")
            }, onCompleted: nil, onDisposed: nil).addDisposableTo(cell.disposeBag)
            
            isSelectable.asDriver().drive(onNext: { [weak self] value in
                self?.selectBtn.setTitle(value ? "キャンセル" : "選択", for: .normal)
                cell.checkboxView.isHidden = !value
            }, onCompleted: nil, onDisposed: nil).addDisposableTo(cell.disposeBag)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.pictureView.image = self.image
            return cell
        }
    }
}
