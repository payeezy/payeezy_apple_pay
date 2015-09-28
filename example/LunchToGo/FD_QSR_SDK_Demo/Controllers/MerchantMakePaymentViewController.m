//
//  MerchantMakePaymentViewController.m
//  FD_QSR_SDK_Demo
//
#import "MerchantMakePaymentViewController.h"
#import "TheDemoMerchant.h"
#import "AppDelegate.h"
#import "QSROrder.h"
#import "QSRCustomer.h"

@interface MerchantMakePaymentViewController ()
{ }
@end

@implementation MerchantMakePaymentViewController

- (void)makePaymentOrAuthorization
{
    NSLog(@"@#@#@#@#@#@#@#@@# ======= NEW TRANSACTION ======= @#@#@#@#@#@#@#@@#" );
    
    //*OSLO Check with SDK whether app can make payments and if so, whether merchant networks are supported
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([FDInAppPaymentProcessor canMakePayments])
    {
        if ([FDInAppPaymentProcessor canMakePaymentsUsingNetworks:[TheDemoMerchant soleInstance].supportedNetworks])
        {
            //*OSLO create FD payment request
            FDPaymentRequest *pmtRqst = [[FDPaymentRequest alloc] init];
            pmtRqst.merchantIdentifier = [TheDemoMerchant soleInstance].merchantIdentifier;
            pmtRqst.supportedNetworks = [TheDemoMerchant soleInstance].supportedNetworks;
            pmtRqst.countryCode = @"US";
            pmtRqst.currencyCode = @"USD";
            pmtRqst.shippingAddress = [QSROrder theOrder].shipTo;
            pmtRqst.merchantCapabilities = FDMerchantCapability3DS;
            
            /*
             @optional - requiredShippingAddressFields, requiredBillingAddressFields
             We illustrate the full set of optional features by requiring full shipping and billing info
             Use the enum value 'FDAddressFieldNone' if your app doesn't require shipping and/or billing info
             */
            
            pmtRqst.requiredShippingAddressFields = FDAddressFieldAll;
            pmtRqst.requiredBillingAddressFields = FDAddressFieldAll;
            
            // Send a sample application data payload -- we have to use the data that matches the signed payload
            NSData *data = [@"This is some test data.  0123456789" dataUsingEncoding:NSUTF8StringEncoding];
            pmtRqst.applicationData = data;

            // SBW -- Get all the items and a total.
            pmtRqst.paymentSummaryItems = [[QSROrder theOrder] fdSummaryItemsWithTotalFromMerchant:[TheDemoMerchant soleInstance]];
            
           // FDShippingMethod *shipping = [[FDShippingMethod alloc] init];
           // FDPaymentSummaryItem *shipping = [[FDPaymentSummaryItem alloc] init];
           // shipping.identifier = @"Two day shipping";
           // shipping.detail = @"Two day shipping continental US";
           // pmtRqst.shippingMethods = @[shipping];
            
           // merchant Ref
            
            pmtRqst.merchantRef = @"Test Order Code:143";
            
            /*
            // Setup test credit card info
            appDelegate.fdPaymentProcessor.creditCardInfo = @{
                                                       @"type":@"visa",
                                                       @"cardholder_name":@"test eck",
                                                       @"card_number":@"4788250000028291",
                                                       @"exp_date":@"1014",
                                                       @"cvv":@"123"
                                                       };
            */
            
            /*
            // Setup test credit card info ---- AMEX TEST
            appDelegate.fdPaymentProcessor.creditCardInfo = @{
                                                              @"type":@"Amex",
                                                              @"cardholder_name":@"John Q Public",
                                                              @"card_number":@"370295007158925",
                                                              @"exp_date":@"0918",
                                                              @"cvv":@"123"
                                                              };
            
            */
            
            // The app can choose which mode to send transactions in: pre-auth only or purchase
            // The default is purchase
            // appDelegate.fdPaymentProcessor.paymentMode = FDPreAuthorization;

            //* OSLO present FD authorization view controller
            BOOL bPaymentOK = [appDelegate.pePaymentProcessor presentPaymentAuthorizationViewControllerWithPaymentRequest:pmtRqst
                                                                             presentingController:self
                                                                                         delegate:self];
            
            // If fails then there is something wrong with your payment request
            if( !bPaymentOK ) {
                
                 UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Payment request was rejected by Apple Pay server" delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
                 [alert show];
                
                NSLog(@"Payment request was rejected by Apple Pay server");
            }else {
                
            }

            // Delegate methods are driving from here...
        }
        else
        {
            //TODO display alertview indicating failiure cause
            NSLog(@"Ability to make payments of network types was rejected by FD SDK");
        }
    }
    else
    {
        //TODO display alertview indicating failiure cause
        NSLog(@"Ability to make payments was rejected by FD SDK");
    }
}



- (IBAction)cancelOrder:(UIButton *)sender
{
    NSLog(@"Making an authorization only request.  Turn control over to FD SDK..");
    QSROrder *order = [QSROrder theOrder];
    order.deleteOrder;
   
}



- (IBAction)makeAuthorization:(UIButton *)sender
{
    NSLog(@"Making an authorization only request.  Turn control over to FD SDK..");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.pePaymentProcessor.paymentMode = FDPreAuthorization;
    [self makePaymentOrAuthorization];
}

- (IBAction)makePayment:(UIButton *)sender
{
    NSLog(@"Making a payment request.  Turn control over to FD SDK..");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.pePaymentProcessor.paymentMode = FDPurchase;
    [self makePaymentOrAuthorization];
}

#pragma mark - FDPaymentAuthorizationViewControllerDelegate

//*OSLO Implement delegate methods

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                       didAuthorizePayment:(FDPaymentResponse *)paymentResponse
{

    NSString *authStatusMessage = nil;
    
    if (!paymentResponse || paymentResponse.validationStatus != FDPaymentValidationStatusSuccess)
    {
        authStatusMessage = @"Transaction Validation or communication failure. Please try again.";
    }
    else if (paymentResponse.authStatus == FDPaymentAuthorizationStatusFailure)
    {
        authStatusMessage = [NSString stringWithFormat:@"Transaction was validated but authorization failed with reason: %@", paymentResponse.transStatusMessage];
                        
    }
    else if (paymentResponse.authStatus == FDPaymentAuthorizationStatusSuccess)
    {
        /* With TA token
        authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rTransarmor Token:%@",
                             paymentResponse.transactionType,
                             paymentResponse.transactionID,
                             paymentResponse.transactionTag,
                             paymentResponse.transarmorToken];
        */
        
        authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@ \r\r For more details, visit developer.payeezy.com",
                             paymentResponse.transactionType,
                             paymentResponse.transactionID,
                             paymentResponse.transactionTag];
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                    message:authStatusMessage delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
    
    //*OSLO maybe the app wants to send the order to the merchant's back-end server now
}


- (void)paymentAuthorizationViewControllerDidFinish:(UIViewController *)controller
{
    // Nothing to do here - the SDK handles all cleanup

    NSLog(@"MerchantMakePaymentViewController:paymentAuthorizationViewControllerDidFinish invoked with controller %@ and retain count %ld", controller, (unsigned long)CFGetRetainCount((__bridge CFTypeRef)(controller)));
}

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                   didSelectShippingMethod:(FDShippingMethod *)shippingMethod
{
    // The customer has asked the merchant to use a specific shipping method.  We need to update the amount.
    // We can also get here if the customer said the heck with it and canceled.
    
    NSLog(@"MerchantMakePaymentViewController:didSelectShippingMethod invoked with controller %@ and retain count %ld",
          controller, (unsigned long)CFGetRetainCount((__bridge CFTypeRef)(controller)));
}

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                  didSelectShippingAddress:(ABRecordRef)address
{
    // The customer is telling the merchant shipping address information.  We need to update the amount.
    // We can also get here if the customer said the heck with it and canceled.

    [QSROrder theOrder].shipTo = address;
    NSLog(@"MerchantMakePaymentViewController:didSelectShippingAddress invoked with controller %@ and retain count %ld", controller,
          (unsigned long)CFGetRetainCount((__bridge CFTypeRef)(controller)));
}

- (void)viewDidAppear:(BOOL)animated
{
    QSRCustomer *customer = [QSRCustomer theCustomer];
    QSROrder *order = [QSROrder theOrder];
    NSMutableAttributedString *orderReport = [order orderReportForCustomer:customer];
    self.orderTextView.attributedText = orderReport;
    [self checkToEnableOrDisableButtons:order];
    
    [super viewDidAppear:animated];
}

-(void)checkToEnableOrDisableButtons:(QSROrder*)order
{
    if(![[order totalOfOrder] isEqual:@(0)]){
        self.makePaymentButton.enabled = YES;
        self.makePaymentButton.alpha = 1.0f;
        self.makeAuthorizationButton.enabled = YES;
        self.makeAuthorizationButton.alpha = 1.0f;
    }else{
        self.makePaymentButton.enabled = NO;
        self.makePaymentButton.alpha = 0.5f;
        self.makeAuthorizationButton.enabled = NO;
        self.makeAuthorizationButton.alpha = 0.5f;
    }
}


@end
