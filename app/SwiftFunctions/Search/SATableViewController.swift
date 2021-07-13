//
//  SATableViewController.swift
//  app
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

var selectIndex = 0//選擇的欄位值
var data :[[String:String]] = []

class SATableViewController: UITableViewController {
    
    //取得textfield的值
    var Item_Name_text :String!
    var Barcode_text :String!
    //取得商品種類的值
    var Item_Category :String!
    
    let myUserDefaults = UserDefaults.standard
    var db :SQLiteConnect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        print(Item_Name_text)
        print(Barcode_text)
        
        let temp = [
            "Barcode" : "Barcode",
            "Item_Name" : "Item_Name",
            "Prime_Cost" : "Prime_Cost",
            "List_Price" : "List_Price",
            "Amount" : "Amount"
        ]
        data.append(temp)
        
        db = SQLiteConnect(file: dbFileName)
        if let mydb = db {
            var input_string = ""
            
            input_string += ("Barcode = \"" + Barcode_text + "\" or Item_Name = \"" + Item_Name_text + "\" or Category = \"" + Item_Category + "\"")
            
            data += mydb.fetch("Item", cond: input_string)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////////////////////////////////////////////////////////////////////////////
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction",
                                                 for: indexPath as IndexPath) as! SATableViewCell
        
        cell.Barcode.text = data[indexPath.row]["Barcode"]
        cell.Item_Name.text = data[indexPath.row]["Item_Name"]
        cell.Prime_Cost.text = data[indexPath.row]["Prime_Cost"]
        cell.List_Price.text = data[indexPath.row]["List_Price"]
        cell.Amount.text = data[indexPath.row]["Amount"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        performSegue(withIdentifier: "ViewTransactionSegue", sender: self)
    }
    ////////////////////////////////////////////////////////////////////////////
    
    @IBAction func Clean_TableView(_ sender: Any) {
        data = []
    }
    
}
