//
//  PriceCalculator.swift
//  app
//
//  Created by PhoenixWrong on 2017/8/26.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation

class PriceCalculator {
    
    init?(){
        
    }
    
    struct Report {//報表的結構
        var Prime :Int = 0//暫定當天總進貨價
        var List :Int = 0//暫定當天出進貨價
    }
    
    func Get_FinancialStatement(_ Transaction_Data :[[String:String]]) -> Dictionary<String,Report> {//回傳報表的圖表，報表內容包含所有交易日子的總進貨價和總出貨價
        var Data = Dictionary<String,Report>()
        
        for i in 0 ..< Transaction_Data.count {
            
            let temp = Transaction_Data[i]["Time_Record"]!
            let index = temp.index(temp.startIndex, offsetBy: 10)
            let Time_Record = temp.substring(to: index)
            
            if Transaction_Data[i]["State"]! == "1" {//出貨
                if Data[Time_Record] == nil {//空的話先初始化
                    let temp_Report = Report(Prime: 0,List: Int(Transaction_Data[i]["Price"]!)! * Int(Transaction_Data[i]["Amount"]!)!)
                    Data.updateValue(temp_Report ,forKey: Time_Record)
                }else {//資料存在就直接對struct內的值做操作
                  Data[Time_Record]?.List += Int(Transaction_Data[i]["Price"]!)! * Int(Transaction_Data[i]["Amount"]!)!
                }
            }else if Transaction_Data[i]["State"]! == "0" {//進貨
                if Data[Time_Record] == nil {//空的話先初始化
                    let temp_Report = Report(Prime: Int(Transaction_Data[i]["Price"]!)! * Int(Transaction_Data[i]["Amount"]!)!,List: 0)
                    Data.updateValue(temp_Report ,forKey: Time_Record)
                }else{//資料存在就直接對struct內的值做操作
                   Data[Time_Record]?.Prime += Int(Transaction_Data[i]["Price"]!)! * Int(Transaction_Data[i]["Amount"]!)!
                }
            }
        }
        return Data
    }
    
    func Get_GrossProfit(_ Transaction_Data :[[String:String]]) -> Int {//回傳毛利率，目前僅用最單純算法：出貨總價扣進貨總價
        
        var Profit :Int! = 0
        for i in 0 ..< Transaction_Data.count {
            if Transaction_Data[i]["State"]! == "1" {//出貨
                Profit! += Int(Transaction_Data[i]["Price"]!)! * Int(Transaction_Data[i]["Amount"]!)!
            }else if Transaction_Data[i]["State"]! == "0" {//進貨
                Profit! -= Int(Transaction_Data[i]["Price"]!)! * Int(Transaction_Data[i]["Amount"]!)!
            }
            
        }
        return Profit
    }
    
    
}
