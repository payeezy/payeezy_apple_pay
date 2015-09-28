//
//  FDPaymentRequest.h
//  FDLibSDK
//
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDPaymentDefs.h"

@import AddressBook;

@interface FDPaymentRequest : NSObject

@property (nonatomic, copy) NSString *merchantIdentifier;                           // Obtained from Acadia developer portal.
@property (nonatomic, copy) NSString *countryCode;                                  // Merchant’s 2-letter ISO country code, for example “US”.
@property (nonatomic, copy) NSArray *supportedNetworks;                             // FDPaymentNetworks supported by the merchant.
@property (nonatomic, copy) NSArray *paymentSummaryItems;                           // FDPaymentSummaryItems to be presented to the user.
                                                                                    // (Tax, shipping, discount...).

@property (nonatomic, assign) FDMerchantCapability merchantCapabilities;


@property (nonatomic, copy) NSString *currencyCode;                                 // ISO 4217 currency code for this transaction, for example “USD”.
@property (nonatomic, copy) NSData *applicationData;                                // (optional) carries application-specific data
@property (nonatomic, assign) FDAddressField requiredShippingAddressFields;         // Selected FDAddressField.  Default is FDShippingAddressFieldNone.
@property (nonatomic, assign) FDAddressField requiredBillingAddressFields;          // Selected requiredBillingAddressFields.  Default is FDShippingAddressFieldNone.
@property (nonatomic, assign) ABRecordRef shippingAddress;                          // Merchant shipping address book entry, if known.
@property (nonatomic, copy) NSArray *shippingMethods;                               // FDPaymentShippingMethods offered by the merchant.
@property (nonatomic, copy) NSString *merchantRef;                                 // Merchant reference code – used by Payeezy system will be reflected in your settlement records and webhook notifications. This is an optional field.


@end
