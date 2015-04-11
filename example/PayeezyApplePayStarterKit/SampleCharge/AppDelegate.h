//
//  AppDelegate.h
//  SampleCharge
//
//  Created by First Data Corporation on 8/28/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

// Establish the developer API key & secret, the merchant processing credential, and the Apple Pay merchantID assigned to this app
// Note: you might want to store these values in a secure location such as the keychain
// This code is for illustration purposes only and should not be used in Production
#ifdef FD_TESTING               // These creds are for the SampleCharge-Testing target
    #define kApiKey             @"y6pWAJNyJyjGv66IsVuWnklkKUPFbb0a" //replace this with your Payeezy API Key
    #define kApiSecret          @"86fbae7030253af3cd15faef2a1f4b67353e41fb6799f576b5093ae52901e6f7" //replace this with your Payeezy API Secret
    #define kMerchantToken      @"fdoa-a480ce8951daa73262734cf102641994c1e55e7cdf4c02b6" //replace this with your Payeezy Token
    #define kApplePayMerchantId @"mock-1" //replace with your merchantID created on Apple Dev Site

    // Point to the test Environment
    #define kEnvironment @"CERT"
#else                           // These creds are for the SampleCharge-iPhone6 Target


#error Payeezy credentials have not been configured
#error You must supply the Payeezy credentials and Apple Pay™ Merchant ID assigned to your App ID
#error To get your own Payeezy credentials, go to  @ "https://developer.payeezy.com"

    #define kApiKey             @"your Payeezy API Key" //replace this with your Payeezy API Key
    #define kApiSecret          @"Your Payeezy API Secret" //replace this with your Payeezy API Secret
    #define kMerchantToken      @"Your Payeezy Token" //replace this with your Payeezy Token
    #define kApplePayMerchantId @"merchant.com.Your ApplePay Merchant ID" //replace with the merchantID assigned to this app on the Apple Developer Site

    // Point to the PROD Environment
    #define kEnvironment @"PROD"

#endif

@class FDInAppPaymentProcessor;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FDInAppPaymentProcessor *pePaymentProcessor;

@end

