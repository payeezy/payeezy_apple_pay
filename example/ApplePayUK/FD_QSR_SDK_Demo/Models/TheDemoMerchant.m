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


    
}

+ (NSString *)displayAsCurrency:(float)amount
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
    NSString *amountString = [formatter stringFromNumber: [NSNumber numberWithFloat: amount]];
    return amountString;
}

- (float)taxRate
{
    return 0.00;  // For Acadia final exam
}

- (NSString *)merchantName
{
    return @"Basildon burger lover!";
}

@end
