//
//  PCInsertViewController.swift
//  app
//
//  Created by apple on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class PCInsertViewController: UIViewController, CategorySentDelegate {
    
    @IBOutlet var int2: UITextField!
    
    @IBOutlet var txF1: UITextField!
    
    @IBOutlet weak var txF2: UILabel!
    
    
    var Barcode_text :String?//接收 PrimeCostMain.storyboard傳過來的barcodw值
    var Amount_text :String! = "0"//新建資料時，單品資料預設為0
    
    let myUserDefaults = UserDefaults.standard
    var db :SQLiteConnect?
    
    func AlertMessageBox(_message :String?){
        let alert = UIAlertController(title: "Alert", message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        db = SQLiteConnect(file: dbFileName)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func executerButton(_ sender: UIButton) {
        if let mydb = db {
            //檢查空格是否有空白的值
            if (txF1.text?.isEmpty)! || (txF2.text?.isEmpty)! || (int2.text?.isEmpty)! {
                AlertMessageBox(_message: "有空格是空值吼!")
            }else {
                let rowInfo = [
                    "Barcode":"'\(Barcode_text ?? "error")'",
                    "Item_Name":"'\(txF1.text ?? "error")'",
                    "Category":"'\(txF2.text ?? "error")'",
                    "Prime_Cost":"'\("0")'",
                    "List_Price":"'\(int2.text ?? "error")'",
                    "Amount":"'\(Amount_text ?? "error")'"
                ]
                _ = mydb.insert("Item", rowInfo: rowInfo)
                performSegue(withIdentifier: "Insert_ToItemData", sender: self)
            }
        }
    }
    
    func SentCategoryData(Category_data: String) {
        txF2.text = Category_data
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Insert_ToItemData"{
            let controller = segue.destination as? PCManualViewController //跳到PrimeCostManual的StoryBoard
            controller?.PC_Barcode_Text = Barcode_text!
            //進入這邊只可能是進貨，所以是0
            controller?.Prime_List_Instruction = 0
        }else if segue.identifier == "GetCategory_FromPrimeCostInsert"{
            let ItemCategory: ItemCategoryViewController = segue.destination as! ItemCategoryViewController
            ItemCategory.Temp_delegate = self
        }
    }
    
}
