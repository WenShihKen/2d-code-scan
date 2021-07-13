//
//  ocpp.m
//  swift_test
//
//  Created by 張語航 on 2017/7/7.
//  Copyright © 2017年 張語航. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ocpp.h"
#include "sql.hpp"



@implementation MyOCPPClass

Data_Info A;

- (int)testFunc {
    return 1;
}

-(void)creatTab {
    A.Initial_Table();
}

-(void)inserting :(NSString*)identify a: (NSString*)item_name
                b: (NSString*) category
                c: (NSString*) image
                d: (int) purchase
                e: (int) shipment
                f: (int) amount
{
    std::string ide([identify UTF8String]);
    std::string itm([item_name UTF8String]);
    std::string catgy([category UTF8String]);
    std::string img([image UTF8String]);
    A.Insert_ItemTable(ide, itm, catgy, img, purchase, shipment, amount);
}
@end
