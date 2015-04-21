//
//  PKPaymentDefs.h
//  FDLibSDK
//
//  Created by Stephan B Wessels on 6/23/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
//  THIS IS A MOCK OF Acadia's SDK

typedef NS_OPTIONS(NSUInteger, PKMerchantCapability) {
    PKMerchantCapability3DS = 1UL << 0,
    PKMerchantCapabilityEMV = 1UL << 1
} NS_ENUM_AVAILABLE(NA, 8_0);

typedef NS_OPTIONS(NSUInteger, PKAddressField) {
    // No address fields required
    PKAddressFieldNone = 0UL,
    
    // Full street address required
    PKAddressFieldPostalAddress = 1UL << 0,
    
    // Phone number required
    PKAddressFieldPhone = 1UL << 1,
    
    // email address required
    PKAddressFieldEmail = 1UL << 2,
    
    // All of the above
    PKAddressFieldAll = (PKAddressFieldPostalAddress | PKAddressFieldPhone | PKAddressFieldEmail)
} ;

typedef NS_ENUM(NSInteger, PKPaymentAuthorizationStatus) {
    PKPaymentAuthorizationStatusSuccess,
    PKPaymentAuthorizationStatusFailure,
    PKPaymentAuthorizationStatusInvalidBillingPostalAddress,    // Merchant refuses service to this billing address.
    PKPaymentAuthorizationStatusInvalidShippingPostalAddress,   // Merchant refuses service to this shipping address.
    PKPaymentAuthorizationStatusInvalidShippingContact          // Supplied contact information is insufficient.
} NS_AVAILABLE(NA, 8_0);

#define PKPaymentNetworkVisa @"Visa"
#define PKPaymentNetworkMasterCard  @"MasterCard"
#define PKPaymentNetworkAmex @"AmEx"

//JTE ChinaUnionPay
