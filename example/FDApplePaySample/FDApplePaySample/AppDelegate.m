//
//  AppDelegate.m
//  FDApplePaySample
//
//  Created by Raghu Vamsi on 6/1/15.
//  Copyright (c) 2015 Raghu Vamsi. All rights reserved.
//

#import "AppDelegate.h"
#import <InAppSDK/InAppSDK.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initApplePay];
    return YES;
}

// Initialize the Payeezy Apple Pay interface
- (void)initApplePay
{
    // Instantiate and initialize the singleton object that you'll interact with to make Apple Pay payments
    // through the Payeezy platform
    self.pePaymentProcessor = [[FDInAppPaymentProcessor alloc] initWithApiKey:kApiKey
                                                                    apiSecret:kApiSecret
                                                                merchantToken:kMerchantToken
                                                           merchantIdentifier:kApplePayMerchantId
                                                                  environment:kEnvironment];
    
    // The app can choose which mode to send transactions: pre-auth only or purchase
    // You can set the default here
    self.pePaymentProcessor.paymentMode = FDPreAuthorization; //FDPurchase; //FDPreAuthorization;
}
@end
