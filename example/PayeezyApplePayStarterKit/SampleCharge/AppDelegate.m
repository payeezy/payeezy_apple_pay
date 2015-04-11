//
//  AppDelegate.m
//  SampleCharge
//
//  Created by First Data Corporation on 8/28/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import "AppDelegate.h"

// This pulls in all the Apple Pay support your app needs
#import <InAppSDK/InAppSDK.h>

// Only include this header when testing; it is not needed for PROD builds
#ifdef FD_TESTING
#import <MockAcadiaAPIs/MockAcadiaAPIs.h>
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize the Payeezy Apple Pay interface
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
    self.pePaymentProcessor.paymentMode = FDPreAuthorization;
    
    // !!IMPORTANT!!
    // If building in test mode, set credentials on the Payeezy service
    // that simulates the Apple Pay service.
#ifdef FD_TESTING
    [RewrapService initWithAPIKey:kApiKey secret:kApiSecret token:kMerchantToken];
#endif
}


@end