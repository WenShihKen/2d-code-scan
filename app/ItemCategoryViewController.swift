//
//  ItemCategoryViewController.swift
//  app
//
//  Created by PhoenixWrong on 2017/8/19.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

var Category_Data :[[String:String]] = []

protocol CategorySentDelegate {
    func SentCategoryData (Category_data: String)
}

class ItemCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var Category_TableView: UITableView!
    
    var db :SQLiteConnect?
    let myUserDefaults = UserDefaults.standard
    var temp_CategoryValue :String?
    
    var Temp_delegate: CategorySentDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        Category_Data = []
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        db = SQLiteConnect(file: dbFileName)
        if let mydb = db {
            Category_Data += mydb.fetch("Species", cond: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category_Data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Category_Cell")
        cell.textLabel?.text = Category_Data[indexPath.row]["Category"]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)!
        temp_CategoryValue = currentCell.textLabel!.text
        
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let dbFileName = self.myUserDefaults.object(forKey: "dbFileName") as! String
            
            self.db = SQLiteConnect(file: dbFileName)
            if let mydb = self.db {
                var input_string = ""
                
                input_string += ("Category = \"" + Category_Data[indexPath.row]["Category"]! + "\"")
                mydb.delete("Species", cond: input_string)
            }
            Category_Data.remove(at: indexPath.row)
            self.Category_TableView.reloadData()
        }
    }
    ///////////////////////////////
    
    
    @IBAction func Back_Button(_ sender: Any) {//返回按鈕
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Add_NewCategory(_ sender: Any) {//新增商品種類並插入到資料庫的按鈕
        
        //要加入showMessageBox來輸入值
        let alert = UIAlertController(title: "新增商品分類", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = nil
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {
            (action: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action: UIAlertAction!) in
            let textField = alert.textFields![0]
            let dbFileName = self.myUserDefaults.object(forKey: "dbFileName") as! String
            self.db = SQLiteConnect(file: dbFileName)
            
            if !(textField.text?.isEmpty)! {//先行判斷有沒有輸入商品種類，沒有就略過插入資料庫行為
                if let mydb = self.db {
                    let row = [
                        "Category":"'\(textField.text!)'"
                    ]
                    _ = mydb.insert("Species", rowInfo: row)
                }
            }
            //要補輸入完種類之後tableview要立刻更新
            Category_Data = []
            self.db = SQLiteConnect(file: dbFileName)
            if let mydb = self.db {
                Category_Data += mydb.fetch("Species", cond: nil)
            }
            self.Category_TableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func Finish_SelectCategory_Button(_ sender: Any) {//選擇商品種類完成，並將商品種類名稱回傳到先前的頁面
        if Temp_delegate != nil{
            if temp_CategoryValue != nil {
                Temp_delegate?.SentCategoryData(Category_data: temp_CategoryValue!)
                dismiss(animated: true, completion: nil)
            }else {//防止不選擇商品種類按完成無法離開視窗的問題
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //對於按鈕的一些動畫演示
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}
