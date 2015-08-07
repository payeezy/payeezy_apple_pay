//
//  AppDelegate.h
//  FDApplePaySample
//
//  Created by Raghu Vamsi on 6/1/15.
//  Copyright (c) 2015 Raghu Vamsi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <InAppSDK/InAppSDK.h>


/* Cert/Demo enviroment for test and integartion */
#define kEnvironment @"CERT"

/* Refer to dev portal -> 'My APIs' page -> app -> API Key */
#define kApiKey             @"kJ0bejUU3FrAUSAKp6DHZYDkdFKYgcj9"

/* Refer to dev portal -> 'My APIs' page -> app -> Api Secret */
#define kApiSecret          @"49b1d4dbe0446711d1435f2a32ce2eea55dfe8681fc2e1c9666b8e5b5218ffe8"

/* Refer to dev portal -> 'My Merchants' page -> SANDBOX -> Token */
#define kMerchantToken      @"fdoa-a480ce8951daa73262734cf102641994c1e55e7cdf4c02b6"

/* Refer to dev portal -> 'My Merchants' page -> SANDBOX -> App Label */
#define kApplePayMerchantId @"merchant.com.cert.PPO014"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FDInAppPaymentProcessor *pePaymentProcessor;


@end

