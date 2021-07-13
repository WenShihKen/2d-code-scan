//
//  ocpp.h
//  swift_test
//
//  Created by 張語航 on 2017/7/7.
//  Copyright © 2017年 張語航. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOCPPClass: NSObject

-(int)testFunc;
-(void)creatTab;
-(void)inserting: (NSString*)identify a:(NSString*)item_name
               b:(NSString*) category
               c:(NSString*)image
               d:(int)purchase
               e:(int) shipment
               f:(int)amount;

@end
