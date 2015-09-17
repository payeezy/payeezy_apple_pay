//
//  AppDelegate.h
//  FD_QSR_SDK_Demo


#import <UIKit/UIKit.h>
#import <InAppSDK/InAppSDK.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FDInAppPaymentProcessor *pePaymentProcessor;

@end

