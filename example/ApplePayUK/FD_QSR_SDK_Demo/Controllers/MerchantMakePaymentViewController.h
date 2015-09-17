//
//  MerchantMakePaymentViewController.h
//  FD_QSR_SDK_Demo


#import <UIKit/UIKit.h>

//*OSLO Import the FD SDK master header file for delegate protocol
#import <InAppSDK/InAppSDK.h>

@interface MerchantMakePaymentViewController : UIViewController <FDPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (weak, nonatomic) IBOutlet UIButton *makeAuthorizationButton;
@property (weak, nonatomic) IBOutlet UIButton *editOrderButton;
@property (weak, nonatomic) IBOutlet UITextView *orderTextView;

- (IBAction)makePayment:(UIButton *)sender;
- (IBAction)makeAuthorization:(UIButton *)sender;
- (IBAction)cancelOrder:(UIButton *)sender;

@end
