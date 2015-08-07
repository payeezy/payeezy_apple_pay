//
//  AppDelegate.m
//  FD_QSR_SDK_Demo


#import <InAppSDK/InAppSDK.h>

#import "AppDelegate.h"
#import "TheDemoMerchant.h"
#import "QSROrder.h"
#import "QSRDemoConstants.h"


@implementation AppDelegate

- (void)instantiateFDLibService {
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

// !! This is only needed for testing
- (void)registerDefaultTestValues {

    //
    // Setup test card defaults
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:@"environment"] == nil){
        NSDictionary *appDefaults = @{@"environment":@"TEST",
                                      @"cavv":@"ADV8726487nmbhdwedgvhvsvznc=",
                                      @"type":@"visa",
                                      @"cardholder_name":@"Unknown",
                                      @"card_number":@"4788250000028291",
                                      @"exp_date":@"1014",
                                      @"cvv":@"123",
                                      @"apikey":kApiKey,
                                      @"merchant_token":kMerchantToken
                                      };
        [defaults registerDefaults:appDefaults];
        [defaults setValuesForKeysWithDictionary:appDefaults];
        [defaults synchronize];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self instantiateFDLibService];
    [self loadOrder];
    [NSThread sleepForTimeInterval:1.0];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveOrder];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self loadOrder];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

- (void)loadOrder
{
    [[QSROrder theOrder] loadPersistentData];
}

- (void)saveOrder
{
    [[QSROrder theOrder] savePersistentData];
}


@end
