//
//  ViewController.m
//  FDApplePaySample
//
//  Created by Raghu Vamsi on 6/1/15.
//  Copyright (c) 2015 Raghu Vamsi. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <InAppSDK/InAppSDK.h>

#define CURRENCY_CODE @"USD"
#define COUNTRY_CODE  @"US"

@interface ViewController ()<UITextFieldDelegate,FDPaymentAuthorizationViewControllerDelegate>

@property (nonatomic)  UITextField *amountField;

@property (nonatomic)  UIButton *payButton;

@property (nonatomic) UIAlertView* alert;

@property (nonatomic) unichar appleLogo;

@property (nonatomic) NSArray *supportedNetworks;



- (IBAction)payAction:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.appleLogo = (unichar) strtol([@"0xf8ff" UTF8String], NULL, 16);
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupAmountAndPayButton];
}


- (void)setupAmountAndPayButton{
    
    self.txtAmount.delegate = self;
    [self.txtAmount becomeFirstResponder];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payAction:)];
    [self.imgButton addGestureRecognizer:tapGesture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [self formatCurrency:textField string:string];
    
    return NO;
    
}

- (void)formatCurrency:(UITextField *)textField string:(NSString *)string {
    NSString *cleanCentString = [[textField.text
                                  componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                 componentsJoinedByString:@""];
    
    
    // Parse final integer value
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithMantissa:[cleanCentString integerValue]
                                                               exponent:-2
                                                             isNegative:NO];
    
    NSDecimalNumber *entry = [NSDecimalNumber decimalNumberWithMantissa:[string integerValue]
                                                               exponent:-2
                                                             isNegative:NO];
    
    NSDecimalNumber *multiplier = [NSDecimalNumber decimalNumberWithMantissa:1
                                                                    exponent:1
                                                                  isNegative:NO];
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:2
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:NO];
    NSDecimalNumber *result;
    
    // Check the user input
    if (string.length > 0)
    {
        // Digit added
        result = [price decimalNumberByMultiplyingBy:multiplier withBehavior:handler];
        result = [result decimalNumberByAdding:entry];
    }
    else
    {
        // Digit deleted
        result = [price decimalNumberByDividingBy:multiplier withBehavior:handler];
    }
    
    // Write amount with currency symbols to the textfield
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setCurrencyCode:CURRENCY_CODE];
    textField.text = [_currencyFormatter stringFromNumber:result];
}


- (IBAction)payAction:(id)sender {
    
    [self.view endEditing:YES];
    
    self.supportedNetworks = @[
                               FDPaymentNetworkVisa,
                               FDPaymentNetworkMasterCard,
                               FDPaymentNetworkAmericanExpress
                               ];
    
    // Does this device support In-App payments?
    if ([FDInAppPaymentProcessor canMakePayments])
    {
        // Is a card registered on the device for one of the merchant's suported card networks?
        if ([FDInAppPaymentProcessor canMakePaymentsUsingNetworks:self.supportedNetworks])
            
        {
            
            [self processApplePayTransaction];
            
        } else{
            self.alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Merchant supported card types unavailable on the device." delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
            [self.alert show];
            
            NSLog(@"Ability to make payments of merchant-supported network types was rejected");
            
        }
        
    } else {
        self.alert = [[UIAlertView alloc] initWithTitle:@"Caution"
                                                message:@"Current device doesn't support Apple Pay - Default to card entry mode?" delegate:self
                                      cancelButtonTitle:@"NO"
                                      otherButtonTitles:@"YES", nil];
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
    
    
    // if app has set required billing and shipping address in the payment request
    if (paymentResponse.billingAddress != nil)
        NSLog(@"Billing Address: %@",[self addressToDictionary:paymentResponse.billingAddress]);
    else
        NSLog(@"Billing Address not requested by App");
    
    if (paymentResponse.shippingAddress != nil)
        NSLog(@"Shipping Address: %@",[self addressToDictionary:paymentResponse.shippingAddress]);
    else
        NSLog(@"Shipping Address not requested by App");
    
    
    // Display message according to the payment response received
    NSString *authStatusMessage = nil;
    
    if (!paymentResponse || paymentResponse.validationStatus != FDPaymentValidationStatusSuccess)
    {
        authStatusMessage = @"Transaction Validation or communication failure. Please try again.";
    }
    else if ([paymentResponse.transStatusMessage isEqualToString:@"APPROVED"])
    {
        authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@",
                             paymentResponse.transactionType,
                             paymentResponse.transactionID,
                             paymentResponse.transactionTag];
    }
    else if (paymentResponse.authStatus == FDPaymentAuthorizationStatusSuccess)
    {
        authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@",
                             paymentResponse.transactionType,
                             paymentResponse.transactionID,
                             paymentResponse.transactionTag];
    }
    else if (paymentResponse.authStatus == FDPaymentAuthorizationStatusFailure)
    {
        authStatusMessage = [NSString stringWithFormat:@"Transaction was validated but authorization failed with reason: %@", paymentResponse.transStatusMessage];
        
    }
    
    
    self.amountField.text = @"";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                    message:authStatusMessage delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
    
    // App can send order to the merchant's back-end server now
}

- (void)paymentAuthorizationViewControllerDidFinish:(UIViewController *)controller
{
    // Apple Pay transaction is now complete - Post Apple Pay:methods could be invoked from here
    
    //NSLog(@"ViewController:paymentAuthorizationViewControllerDidFinish invoked");
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

- (void)processApplePayTransaction {
    
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
            pmtRqst.countryCode = COUNTRY_CODE;
            pmtRqst.currencyCode = CURRENCY_CODE;
            pmtRqst.merchantCapabilities = FDMerchantCapability3DS;
            
            NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"$£"];
            NSString* amountToBePaid = [self.txtAmount.text stringByTrimmingCharactersInSet:chs];
            
            /*
             @optional - requiredShippingAddressFields, requiredBillingAddressFields
             We illustrate the full set of optional features by requiring full shipping and billing info
             Use the enum value 'FDAddressFieldNone' if your app doesn't require shipping and/or billing info
             */
            
            pmtRqst.requiredShippingAddressFields = FDAddressFieldAll;
            pmtRqst.requiredBillingAddressFields = FDAddressFieldAll;
            
            /*
             @optional - merchantRef
             Merchant reference code – used by Payeezy system will be reflected in your settlement records and webhook notifications
             */
            
            pmtRqst.merchantRef = @"Sample-Charge-Payeezy-Demo-App";
            
            
            /*
             @required - paymentMode
              Set the payment mode: pre-authorization only or purchase
             */

            appDelegate.pePaymentProcessor.paymentMode = (self.segTransType.selectedSegmentIndex==0 ? FDPreAuthorization : FDPurchase);

            
            /*
             @optional - shippingMethods
             Merchants can set shipping methods using the below sample code.
             */
            
            /*
             FDShippingMethod *shippingOvernight = [[FDShippingMethod alloc] initWithIdentifier:@"ON"
             detail:@"Guaranteed overnight"
             amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]
             label:@"Overnight Shipping"];
             
             FDShippingMethod *shippingTwoDay= [[FDShippingMethod alloc] initWithIdentifier:@"2D"
             detail:@"Ships within two business days "
             amount:[NSDecimalNumber decimalNumberWithString:@"4.00"]
             label:@"Two Day Shipping"];
             
             pmtRqst.shippingMethods = @[shippingOvernight, shippingTwoDay];
             */
            
            
            
            /*
             @required - paymentSummaryItems
             Apple Pay payment request requires paymentSummaryItems to be set which shall include  tax, shipping & other charges
             */

            // Creating a sample order with only one line item
            FDPaymentSummaryItem *item1 = [[FDPaymentSummaryItem alloc] init];
            item1.label = @"Large Shoes";
            item1.amount = [NSDecimalNumber decimalNumberWithString:amountToBePaid];
            
            // Total line
            // The list line item must be the merchant's name and reflect the TOTAL amount being authorized
            // (including tax, shipping, other charges)
            FDPaymentSummaryItem *item2 = [[FDPaymentSummaryItem alloc] init];
            item2.label = @"Mcc Test Mid";
            item2.amount = [NSDecimalNumber decimalNumberWithString:amountToBePaid];
            NSArray *itemArray = [NSArray arrayWithObjects: item1, item2, nil];
            pmtRqst.paymentSummaryItems = itemArray;
            
            
            /*
             @required - applicationData
             Merchants could use this field to provide any info about the order. Payeezy returns the same info via webhook back to merchants if configured.
             */
            
            // Send a sample application data payload
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

-(NSDictionary*) addressToDictionary:(ABRecordRef)address
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for ( int32_t propertyIndex = kABPersonFirstNameProperty; propertyIndex <= kABPersonSocialProfileProperty; propertyIndex ++ )
    {
        NSString* propertyName = CFBridgingRelease(ABPersonCopyLocalizedPropertyName(propertyIndex));
        id value = CFBridgingRelease(ABRecordCopyValue(address, propertyIndex));
        
        if ( value )
            [dictionary setObject:value forKey:propertyName];
    }
    return dictionary;
}
@end
