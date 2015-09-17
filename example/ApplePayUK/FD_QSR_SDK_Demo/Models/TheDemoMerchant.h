//
//  TheDemoMerchant.h
//  FD_QSR_SDK_Demo


#import <Foundation/Foundation.h>

@interface TheDemoMerchant : NSObject

@property (nonatomic, copy) NSString *merchantIdentifier;       // Obtained from Acadia developer portal.
@property (nonatomic, copy) NSArray *supportedNetworks;         // FDPaymentNetworks supported by the merchant.
@property (nonatomic, copy) NSArray *shippingMethods;           // Shipping methods supported by the merchant.

+ (TheDemoMerchant *)soleInstance;
+ (NSString *)displayAsCurrency:(float)amount;
- (float)taxRate;
- (NSString *)merchantName;

@end
