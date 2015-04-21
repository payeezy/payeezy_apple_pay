//
//  PKPaymentRequest.h
//  FDLibSDK
//
//  Created by Stephan B Wessels on 6/23/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
//  THIS IS A MOCK OF Acadia's SDK

#import <Foundation/Foundation.h>
#import "PKPaymentDefs.h"

@import AddressBook;

@interface PKPaymentRequest : NSObject

@property (nonatomic, copy) NSString *merchantIdentifier;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSArray *supportedNetworks;
@property (nonatomic, assign) PKMerchantCapability merchantCapabilities;
@property (nonatomic, copy) NSArray *paymentSummaryItems;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSData *applicationData;
@property (nonatomic, assign) PKAddressField requiredShippingAddressFields;
@property (nonatomic, assign) PKAddressField requiredBillingAddressFields;
@property (nonatomic, assign) ABRecordRef shippingAddress;
@property (nonatomic, copy) NSArray *shippingMethods;

@end
