//
//  PKPayment.h
//  FDLibSDK
//
//  Created by Stephan B Wessels on 6/23/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
//  THIS IS A MOCK OF Acadia's SDK

#import <Foundation/Foundation.h>

@class PKPayment, PKPaymentToken, PKPaymentRequest, PKShippingMethod;



@import AddressBook;

@interface PKPayment : NSObject

@property (nonatomic, readonly) PKPaymentToken *token;          // The PKPaymentToken containing the payment credential generated for the request.
@property (nonatomic, readonly) ABRecordRef shippingAddress;    // The full shipping address that the user selected for this transaction.
@property (nonatomic, readonly) ABRecordRef billingAddress;     // The full billing address that the user selected for this transaction.
@property (nonatomic, readonly) PKShippingMethod *shippingMethod;

@end
