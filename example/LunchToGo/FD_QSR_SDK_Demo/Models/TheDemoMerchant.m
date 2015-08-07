//
//  TheDemoMerchant.m
//  FD_QSR_SDK_Demo

#import <InAppSDK/InAppSDK.h>

#import "TheDemoMerchant.h"
#import "QSRDemoConstants.h"

@implementation TheDemoMerchant

+ (TheDemoMerchant *)soleInstance
{
    static dispatch_once_t onceToken;
    static TheDemoMerchant *soleInstance;
    dispatch_once(&onceToken, ^{
        soleInstance = [[self alloc] init];
    });
    return soleInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    self.merchantIdentifier = kApplePayMerchantId;
    self.supportedNetworks = [self availablePaymentNetworks];
    self.shippingMethods = [self availableShippingMethods];
    return self;
}

- (NSArray *)availablePaymentNetworks
{
    return @[
             FDPaymentNetworkVisa,
             FDPaymentNetworkMasterCard,
             FDPaymentNetworkAmericanExpress
             ];
}

- (NSArray *)availableShippingMethods
{
    
    FDShippingMethod *shippingOvernight = [[FDShippingMethod alloc] initWithIdentifier:@"ON"
                                                                                detail:@"Guaranteed overnight"
                                                                                amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]
                                                                                 label:@"Overnight Shipping"];
    
    FDShippingMethod *shippingTwoDay= [[FDShippingMethod alloc] initWithIdentifier:@"2D"
                                                                            detail:@"Ships within two business days "
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"4.00"]
                                                                             label:@"Two Day Shipping"];
    
    return @[shippingOvernight, shippingTwoDay];

//    return @[
//             [[FDShippingMethod alloc] initShippingMethodLabel:@"USA First Class"
//                                                        amount:[[NSDecimalNumber alloc] initWithFloat:1.00f]
//                                                        detail:@"Delivery time estimated from 3-14 days.  This method is only listed for orders less than a pound weight. Items on back order will be shipped via USA First Class. Includes Delivery confirmation tracking"],
//             [[FDShippingMethod alloc] initShippingMethodLabel:@"USA Priority"
//                                                        amount:[[NSDecimalNumber alloc] initWithFloat:2.00f]
//                                                        detail:@"Delivery time estimated from 2-8 days. Includes delivery confirmation tracking"],
//             [[FDShippingMethod alloc] initShippingMethodLabel:@"UPS 2nd Day"
//                                                        amount:[[NSDecimalNumber alloc] initWithFloat:1.00f]
//                                                        detail:@"This service offers full tracking capabilities and guaranteed time-frame delivery. Orders placed after noon will ship the next day. Delivery only applies on weekdays. Items on back order will be shipped via USA First Class."],
//             [[FDShippingMethod alloc] initShippingMethodLabel:@"UPS 3 Day"
//                                                        amount:[[NSDecimalNumber alloc] initWithFloat:0.75f]
//                                                        detail:@"This service offers full tracking capabilities and guaranteed time-frame delivery. Orders placed after noon will ship the next day. Delivery only applies on weekdays. Items on back order will be shipped via USA First Class."],
//             [[FDShippingMethod alloc] initShippingMethodLabel:@"UPS Ground"
//                                                        amount:[[NSDecimalNumber alloc] initWithFloat:0.50f]
//                                                        detail:@"This service offers full tracking capabilities and guaranteed time-frame delivery. Orders placed after noon will ship the next day. Delivery only applies on weekdays. Items on back order will be shipped via USA First Class."]
//             ];
    
}

+ (NSString *)displayAsCurrency:(float)amount
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *amountString = [formatter stringFromNumber: [NSNumber numberWithFloat: amount]];
    return amountString;
}

- (float)taxRate
{
    return 0.00;  // For Acadia final exam
}

- (NSString *)merchantName
{
    return @"Lunch To-Go!";
}

@end
