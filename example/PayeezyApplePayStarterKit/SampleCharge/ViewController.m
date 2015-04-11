//
//  ViewController.m
//  SampleCharge
//
//  Created by First Data Corporation on 8/28/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import "ViewController.h"
#import <sys/sysctl.h>
#import "AppDelegate.h"

// This pulls in all the Apple Pay support your app needs
#import <InAppSDK/InAppSDK.h>


@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)payClicked:(id)sender {

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSArray *supportedNetworks = @[
                                   FDPaymentNetworkVisa,
                                   FDPaymentNetworkMasterCard,
                                   FDPaymentNetworkAmericanExpress
                                   ];
    
    // Does this device support In-App payments?
    if ([FDInAppPaymentProcessor canMakePayments])
    {
        // Is a card registered on the device for one of the merchant's suported card networks?
        if ([FDInAppPaymentProcessor canMakePaymentsUsingNetworks:supportedNetworks])
        {
            // Populate the payment request
            FDPaymentRequest *pmtRqst = [[FDPaymentRequest alloc] init];
            
            pmtRqst.merchantIdentifier = kApplePayMerchantId;

            pmtRqst.supportedNetworks = supportedNetworks;
            pmtRqst.countryCode = @"US";
            pmtRqst.currencyCode = @"USD";
            pmtRqst.merchantCapabilities = FDMerchantCapability3DS;
            
            // Optional params
            // We illustrate the full set of optional features by requiring full shipping and billing info
            // Use the enum value 'FDAddressFieldNone' if your app doesn't require shipping and/or billing info
            pmtRqst.requiredShippingAddressFields = FDAddressFieldAll;
            pmtRqst.requiredBillingAddressFields = FDAddressFieldAll;
            
            // Merchant reference code – used by Payeezy system will be reflected in your settlement records and webhook notifications
            pmtRqst.merchantRef = @"Sample-Charge-Payeezy-Demo-App";
            
            // Set the payment mode: pre-authorization only or purchase
            appDelegate.pePaymentProcessor.paymentMode = (self.segPaymentType.selectedSegmentIndex==0 ? FDPreAuthorization : FDPurchase);
            
            
            //
            // Set (sample) shipping methods
            //
            FDShippingMethod *shippingOvernight = [[FDShippingMethod alloc] initWithIdentifier:@"ON"
                                                                                        detail:@"Guaranteed overnight"
                                                                                        amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]
                                                                                         label:@"Overnight Shipping"];
            
            FDShippingMethod *shippingTwoDay= [[FDShippingMethod alloc] initWithIdentifier:@"2D"
                                                                                    detail:@"Ships within two business days "
                                                                                    amount:[NSDecimalNumber decimalNumberWithString:@"4.00"]
                                                                                     label:@"Two Day Shipping"];
            
            pmtRqst.shippingMethods = @[shippingOvernight, shippingTwoDay];
            
            // Create a sample order with only one line item
            FDPaymentSummaryItem *item1 = [[FDPaymentSummaryItem alloc] init];
            item1.label = @"Large Shoes";
            item1.amount = [NSDecimalNumber decimalNumberWithString:self.txtAmount.text];
            
            // Total line
            // The list line item must be the merchant's name and reflect the TOTAL amount being authorized
            // (including tax, shipping, other charges)
            FDPaymentSummaryItem *item2 = [[FDPaymentSummaryItem alloc] init];
            item2.label = @"FD Test Merchant1";
            item2.amount = [NSDecimalNumber decimalNumberWithString:self.txtAmount.text];
            NSArray *itemArray = [NSArray arrayWithObjects: item1, item2, nil];
            pmtRqst.paymentSummaryItems = itemArray;
            
            // Optional Apple Pay parameter - Send a sample application data payload
            NSString *appDataString = @"RefCode:12345; TxID:34234089240982304823094823432";
            pmtRqst.applicationData = [appDataString dataUsingEncoding:NSUTF8StringEncoding];
            
            //
            // DISPLAY THE APPLE PAY AUTHORIZATION SHEET (which prompts the user to authorize via TouchID)
            //
            BOOL bPaymentOK = [appDelegate.pePaymentProcessor presentPaymentAuthorizationViewControllerWithPaymentRequest:pmtRqst presentingController:self delegate:self];
            
            // If fails then there is something wrong with your payment request
            if( !bPaymentOK ) {
                
                self.alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Payment request was rejected by Apple Pay server" delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
                [self.alert show];
                
                NSLog(@"Payment request was rejected by Apple Pay server");
            }
            
            // Delegate methods are driving from here...
        }
        else
        {
            self.alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Ability to make payments of merchant-supported network types was rejected" delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
            [self.alert show];
            
            NSLog(@"Ability to make payments of merchant-supported network types was rejected");
        }
    }
    else
    {
        self.alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                message:@"This device does not support Apple Pay! You must run this app on an iPhone 6, iPhone 6 Plus, iPhone Air 2 or an iPad Mini 3" delegate:self
                                      cancelButtonTitle:@"Dismiss"
                                      otherButtonTitles:nil];
        [self.alert show];
        NSLog(@"Ability for device to make payments was rejected");
    }
}


#pragma mark - FDPaymentAuthorizationViewControllerDelegate

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                       didAuthorizePayment:(FDPaymentResponse *)paymentResponse
{
    // The user has authorized the transaction from the device
    // Now you'll see whether the transaction has been successfully processed (e.g. authorized/declined/error)
    
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
        authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@",
                             paymentResponse.transactionType,
                             paymentResponse.transactionID,
                             paymentResponse.transactionTag];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                    message:authStatusMessage delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
    
    // App can send order to the merchant's back-end server now
}

- (void)paymentAuthorizationViewControllerDidFinish:(UIViewController *)controller
{
    // Nothing to do here - the SDK handles all cleanup
    
    NSLog(@"ViewController:paymentAuthorizationViewControllerDidFinish invoked");
}

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                   didSelectShippingMethod:(FDShippingMethod *)shippingMethod
{
    // The customer has asked the merchant to use a specific shipping method.
    // You may need to keep track of the new shipping method and possibly update the transaction amount.
    
    NSLog(@"ViewController:didSelectShippingMethod invoked");
}

- (void)paymentAuthorizationViewController:(UIViewController *)controller
                  didSelectShippingAddress:(ABRecordRef)address
{
    // The customer is selecting the shipping address information.
    // You may need to keep track of the new shipping address.
    
    NSLog(@"ViewController:didSelectShippingAddress invoked");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
