//
//  FDPaymentAuthorizationViewControllerDelegate.h
//  FDLibSDK
//
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDPaymentResponse;
@class FDShippingMethod;
@import AddressBook;

@protocol FDPaymentAuthorizationViewControllerDelegate <NSObject>

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                       didAuthorizePayment:(FDPaymentResponse *)payment;

- (void)paymentAuthorizationViewControllerDidFinish:(UIViewController *)controller;

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                   didSelectShippingMethod:(FDShippingMethod *)shippingMethod;

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                  didSelectShippingAddress:(ABRecordRef)address;
@end
