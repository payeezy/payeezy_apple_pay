//
//  PKPaymentSummaryItem.h
//  FDLibSDK
//
//  Created by Stephan B Wessels on 6/23/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
//  THIS IS A MOCK OF Acadia's SDK

#import <Foundation/Foundation.h>

@interface PKPaymentSummaryItem : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSDecimalNumber *amount;

+ (instancetype)summaryItemWithLabel:(NSString *)label amount: (NSDecimalNumber *)amount;

@end
