//
//  PKShippingMethod.h
//  FDLibSDK
//
//  Created by Stephan B Wessels on 6/23/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
//  THIS IS A MOCK OF Acadia's SDK

#import <Foundation/Foundation.h>
#import "PKPaymentDefs.h"
#import "PKPaymentSummaryItem.h"

@interface PKShippingMethod : PKPaymentSummaryItem

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *detail;

@end
