//
//  PKPaymentAuthorizationViewController.h
//  FDLibSDK
//
//  Created by Stephan B Wessels on 6/23/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
//  THIS IS A MOCK OF Acadia's SDK

#import <UIKit/UIKit.h>
#import "PKPaymentAuthorizationViewControllerDelegate.h"

@class PKPaymentRequest;

@interface PKPaymentAuthorizationViewController : UIViewController

@property (nonatomic, weak) id <PKPaymentAuthorizationViewControllerDelegate> delegate;

+ (BOOL)canMakePayments;
+ (BOOL)canMakePaymentsUsingNetworks:(NSArray *)supportedNetworks;
- (instancetype)initWithPaymentRequest:(PKPaymentRequest *)paymentRequest;
- (IBAction)authorizePayment:(UIButton *)sender;
- (IBAction)cancelPayment:(UIButton *)sender;
- (IBAction)changeShippingInfo:(UIButton *)sender;
- (IBAction)changeShippingMethod:(UIButton *)sender;

@end
