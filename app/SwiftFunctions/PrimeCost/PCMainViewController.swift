//
//  PCMainViewController.swift
//  app
//
//  Created by apple on 2017/8/6.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class PCMainViewController: UIViewController, BarcodeSentDelegate {
    
    @IBOutlet var PLswitch: UISegmentedControl!//0是進貨，1是出貨
    
    @IBOutlet var PC_Barcode: UITextField!//條碼textfield的宣告
    
    let myUserDefaults = UserDefaults.standard
    var db :SQLiteConnect?
    
    func AlertMessageBox(_message :String?){
        
        let alert = UIAlertController(title: "Alert", message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Search_Action(_ sender: Any) {
        let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
        if (PC_Barcode.text?.isEmpty)! {//沒輸入值就跳警告
            AlertMessageBox(_message: "有空格是空值吼!")
        }else{//這邊要判斷進出貨
            db = SQLiteConnect(file: dbFileName)
            if PLswitch.selectedSegmentIndex == 0 {//進貨情況
                if let mydb = db {
                    var input_string = ""
                    input_string += ("Barcode = \"" + PC_Barcode.text! + "\"")
                    let stmt = mydb.fetch("Item", cond: input_string)
                    do {
                        if (stmt.count != 0) {
                            print("Yes, Find Item")
                            performSegue(withIdentifier: "PCManualViewController", sender: self)//segue的ＩＤ
                            //跳到PrimeCostManual的StoryBoard
                        } else {
                            print("No Cannot Find, Jump to Insert Page")
                            performSegue(withIdentifier: "PCInsertViewController", sender: self)//segue的ＩＤ
                            //跳到PrimeCostInsert的StoryBoard
                        }
                    }
                }
            }else if PLswitch.selectedSegmentIndex == 1 {//出貨情況
                if let mydb = db {
                    var input_string = ""
                    input_string += ("Barcode = \"" + PC_Barcode.text! + "\"")
                    let stmt = mydb.fetch("Item", cond: input_string)
                    do {
                        if (stmt.count != 0) {
                            print("Yes, Find Item")
                            performSegue(withIdentifier: "PCManualViewController", sender: self)//segue的ＩＤ
                            //跳到PrimeCostManual的StoryBoard
                        } else {
                            AlertMessageBox(_message: "沒資料哦，不能出貨")
                        }
                    }
                }
            }
        }
    }
    
    func SentBarcodeData(Barcode_Data: String) {
        PC_Barcode.text = Barcode_Data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //用來判斷segue到哪個頁面
        if segue.identifier == "PCManualViewController" {//跳到PrimeCostManual
            let controller = segue.destination as? PCManualViewController
            controller?.PC_Barcode_Text = PC_Barcode.text!
            controller?.Prime_List_Instruction = PLswitch.selectedSegmentIndex
        } else if segue.identifier == "PCInsertViewController" {//跳到PrimeCostInsert
            let controller = segue.destination as? PCInsertViewController
            controller?.Barcode_text = PC_Barcode.text!
        } else if segue.identifier == "SearchCameraPage_FromPrimeCostMain"{//跳到SearchCamera
            let ScanBarcode: CamaraViewController = segue.destination as! CamaraViewController
            ScanBarcode.Temp_delegate = self
        }
    }
    
    
}
