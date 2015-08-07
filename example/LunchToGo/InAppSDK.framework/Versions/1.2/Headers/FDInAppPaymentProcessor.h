//
//  FDInAppPaymentProcessor.h
//  FDInAppPaymentProcessor
//
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPaymentDefs.h"
#import "FDPaymentAuthorizationViewControllerDelegate.h"

@class FDPaymentResponse;
@class FDPaymentRequest;

// Note that doesn't explicitly specify implements protocol PKPaymentAuthorizationViewControllerDelegate
// But we don't want to do that here b/c don't want to expose any PK symbols
@interface FDInAppPaymentProcessor : NSObject

+ (BOOL)canMakePayments;

+ (BOOL)canMakePaymentsUsingNetworks:(NSArray *)supportedNetworks;

- (instancetype)initWithApiKey:(NSString *)apiKey
                     apiSecret:(NSString *)apiSecret
                 merchantToken:(NSString *)merchantToken
            merchantIdentifier:(NSString *)merchantIdentifier
                   environment:(NSString *)environment;  // BREAKING CHANGE -- added parameter

// Can pass nil for 'presentingViewController' parameter
- (BOOL)presentPaymentAuthorizationViewControllerWithPaymentRequest:(FDPaymentRequest *)paymentRequest
                               presentingController:(UIViewController *)presentingViewController
                                           delegate:(id<FDPaymentAuthorizationViewControllerDelegate>)aDelegate;

@property (nonatomic, weak) id <FDPaymentAuthorizationViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *merchantIdentifier;
@property (nonatomic, copy) NSData *applicationData;
@property (nonatomic, assign) FDPaymentType paymentMode;
@property (nonatomic, copy) NSString* merchantRef;

@end
