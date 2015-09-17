//
//  FDPaymentSummaryItem.h
//  FDLibSDK
//
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDPaymentSummaryItem : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSDecimalNumber *amount;

+ (instancetype)summaryItemWithLabel:(NSString *)label amount: (NSDecimalNumber *)amount;
- (instancetype)initWithLabel:(NSString *)aLabelString amount: (NSDecimalNumber *)theAmount;

@end
