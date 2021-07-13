//
//  SMViewController.swift
//  app
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class SMViewController: UIViewController, CategorySentDelegate, BarcodeSentDelegate {

    @IBOutlet var SearchThing: UITextField!
    @IBOutlet var Barcode_value: UITextField!
    @IBOutlet weak var Item_Category: UILabel!
    
    var Temp_Item_Category :String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Item_Category.text = Temp_Item_Category
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Press_SearchButton(_ sender: Any) {
        
        if (SearchThing.text?.isEmpty)! && (Barcode_value.text?.isEmpty)! && (Item_Category.text?.isEmpty)! {
            //目前唯一例外，可經由條碼或者名稱搜尋，暫時改&&
            let alert = UIAlertController(title: "Alert", message: "有空格是空值吼!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            performSegue(withIdentifier: "SearchAllPage_FromSearchMain", sender: self)
        }
        
    }
    
    func SentCategoryData(Category_data: String) {
        Item_Category.text = Category_data
    }
    func SentBarcodeData(Barcode_Data: String) {
        Barcode_value.text = Barcode_Data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchAllPage_FromSearchMain"{
            let controller = segue.destination as? SATableViewController
            controller?.Item_Name_text = SearchThing.text!
            controller?.Barcode_text = Barcode_value.text!
            controller?.Item_Category = Item_Category.text!
        }else if segue.identifier == "SearchCameraPage_FromSearchMain"{
            let ScanBarcode: CamaraViewController = segue.destination as! CamaraViewController
            ScanBarcode.Temp_delegate = self
        }else if segue.identifier == "ChooseCategory_FromSearchMain"{
            let ItemCategory: ItemCategoryViewController = segue.destination as! ItemCategoryViewController
            ItemCategory.Temp_delegate = self
        }
    }
 

}
