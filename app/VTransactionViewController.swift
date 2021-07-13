//
//  VTransactionViewController.swift
//  app
//
//  Created by PhoenixWrong on 2017/8/9.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class VTransactionViewController: UIViewController {
    
    @IBOutlet weak var Barcode: UILabel!
    @IBOutlet weak var Item_Name: UILabel!
    @IBOutlet weak var Prime_Cost: UILabel!
    @IBOutlet weak var List_Price: UILabel!
    @IBOutlet weak var Amount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Barcode.text = data[selectIndex]["Barcode"]
        Item_Name.text = data[selectIndex]["Item_Name"]
        Prime_Cost.text = data[selectIndex]["Prime_Cost"]
        List_Price.text = data[selectIndex]["List_Price"]
        Amount.text = data[selectIndex]["Amount"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
