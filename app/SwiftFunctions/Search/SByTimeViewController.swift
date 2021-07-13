//
//  SByTimeViewController.swift
//  app
//
//  Created by apple on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class SByTimeViewController: UIViewController{

    @IBOutlet weak var StartTime: UITextField!
    @IBOutlet weak var EndTime: UITextField!
    
    let datePicker = UIDatePicker()
    
    let myUserDefaults = UserDefaults.standard
    var db :SQLiteConnect?
    var data :[[String:String]] = []
    
    var calcu :PriceCalculator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createStartDatePicker()
        createEndDatePicker()
    }
    
    
    func createStartDatePicker() {
        
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(StartdonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        StartTime.inputAccessoryView = toolbar
        
        StartTime.inputView = datePicker
        
    }
    
    func StartdonePressed(){//把日期填回空格
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        StartTime.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func createEndDatePicker() {
        
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(EnddonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        EndTime.inputAccessoryView = toolbar
        
        EndTime.inputView = datePicker
        
    }
    
    func EnddonePressed(){//把日期填回空格
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        EndTime.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func Press_SearchButton(_ sender: Any) {
        if (StartTime.text?.isEmpty)! || (EndTime.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Alert", message: "有空格是空值吼!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            //執行搜尋，未完成(尚未決定怎麼顯示資料)，以下皆測試使用
            calcu = PriceCalculator()
            
            let dbFileName = myUserDefaults.object(forKey: "dbFileName") as! String
            
            db = SQLiteConnect(file: dbFileName)
            
            if let mydb = db {
                var input_string = ""
                
                input_string += ("Time_Record BETWEEN \"" + StartTime.text! + "\" AND \"" + EndTime.text! + "\"")
                
                data += mydb.fetch("Trans", cond: input_string)
            }
            
            let temp_data = calcu?.Get_FinancialStatement(data)
            let temp_profit = calcu?.Get_GrossProfit(data)
            
            print(temp_profit!)
            print(temp_data!)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
