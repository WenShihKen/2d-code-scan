//
//  SATableViewCell.swift
//  app
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class SATableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var Barcode: UILabel!
    @IBOutlet weak var Item_Name: UILabel!
    @IBOutlet weak var Prime_Cost: UILabel!
    @IBOutlet weak var List_Price: UILabel!
    @IBOutlet weak var Amount: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
