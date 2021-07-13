//
//  PCManualViewController.swift
//  app
//
//  Created by PhoenixWrong on 2017/8/6.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class PCManualViewController: UIViewController {
    
    //接收Barcode的值
    var PC_Barcode_Text :String!
    //用來判斷進貨還是出貨
    var Prime_List_Instruction :Int!
    
    @IBOutlet var Item_Amount: UITextField!
    @IBOutlet var Item_Price: UITextField!
    
    var db :SQLiteConnect?
    let myUserDefaults = UserDefaults.standard
    
    func AlertMessageBox(_message :String?){
        let alert = UIAlertController(title: "Alert", message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Insert_Trigger_Button(_ sender: Any) {
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now_time :String! = (dformatter.string(from: now))
        
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        
        if (Item_Amount.text?.isEmpty)! || (Item_Price.text?.isEmpty)! {
            
            AlertMessageBox(_message: "有空格是空值吼!")
            
        }else{
            db = SQLiteConnect(file: dbFileName)
            var item_database_amount :String!//當前資料庫內的商品數量
            var item_database_prime_cost :String!//當前資料庫的商品總進貨價
            
            if let mydb = db {
                var input_string = ""
                
                input_string += ("Barcode = \"" + PC_Barcode_Text + "\"")
                let stmt = mydb.fetch("Item", cond: input_string)
                do {
                    item_database_amount = stmt[0]["Amount"]!
                    item_database_prime_cost = stmt[0]["Prime_Cost"]
                }
            }
            //進貨時對單品資料庫內的數量為加號，出貨是減號
            var update_item_amount :Int?
            
            var update_item_prime_cost :Int! = 0
            
            if Prime_List_Instruction == 0 {//進貨
                update_item_amount = Int(item_database_amount)! + Int(Item_Amount.text!)!//更新商品資料庫的貨存量
                
                update_item_prime_cost! = Int(Double(item_database_prime_cost)! + Double(Int(Item_Price.text!)! * Int(Item_Amount.text!)!))//更新商品資料庫的總進貨價
                
            }else if Prime_List_Instruction == 1 {//出貨
                update_item_amount = Int(item_database_amount)! - Int(Item_Amount.text!)!//更新商品資料庫的貨存量
                
                let single_item_price :Double! = Double(item_database_prime_cost)! / Double(item_database_amount)!

                update_item_prime_cost! = Int(Double(item_database_prime_cost)! - Double(single_item_price)*Double(Item_Amount.text!)!)//更新商品資料庫的總進貨價(目前是更新進貨總價，以便計算商品之單位成本)

                if update_item_amount! < 0 {
                    AlertMessageBox(_message: "沒貨啦!怎麼出貨?")
                    return
                }
            }
            if let mydb = db {
                let row = [
                    "Time_Record":"'\(now_time!)'",
                    "Barcode":"'\(PC_Barcode_Text!)'",
                    "Amount":"'\(Item_Amount.text!)'",
                    "Price":"'\(Item_Price.text!)'",
                    "State":"'\(Prime_List_Instruction!)'",
                ]
                _ = mydb.insert("Trans", rowInfo: row)
            }
            if let mydb = db {
                var input_string = ""
                input_string += ("Barcode =\"" + PC_Barcode_Text + "\"")
                let rowInfo = [
                    "Prime_Cost":"'\(update_item_prime_cost!)'",
                    "Amount":"'\(update_item_amount!)'"
                ]
                _ = mydb.update("Item", cond: input_string, rowInfo: rowInfo)
            }
            performSegue(withIdentifier: "Insert_ToTransData", sender: self)
            
        }
    }
}
