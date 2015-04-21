//
//  PKPaymentAuthorizationViewControllerDelegate.h
//  FDLibSDK
//
//  Created by Stephan B Wessels on 6/23/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
//  THIS IS A MOCK OF Acadia's SDK

#import <Foundation/Foundation.h>
#import "PKPaymentDefs.h"
#import "PKPayment.h"
#import "PKShippingMethod.h"

@import AddressBook;

@class PKPaymentAuthorizationViewController;

@protocol PKPaymentAuthorizationViewControllerDelegate <NSObject>

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion;

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller;

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus status,
                                                     NSArray *summaryItems))completion;

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingAddress:(ABRecordRef)address
                                completion:(void (^)(PKPaymentAuthorizationStatus status,
                                                     NSArray *shippingMethods,
                                                     NSArray *summaryItems))completion;

@end
