//
//  PKPaymentToken.h
//  FDLibSDK
//
//  Created by First Data Corporation on 6/23/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//
//  THIS IS A MOCK OF Acadia's SDK

#import <Foundation/Foundation.h>

@class PKPaymentRequest, PKPaymentToken;

@interface PKPaymentToken : NSObject

@property (nonatomic, readonly) NSString *paymentInstrumentName;    // Describes the payment instrument the user has selected
// to fund the payment.
// Suitable for display, e.g. “Visa 1234”.

@property (nonatomic, readonly) NSString *paymentNetwork;           // Payment network for the card that funds the payment.

@property (nonatomic, readonly) NSString *transactionIdentifier;    // Describes a globally unique identifier for this
// transaction that the merchant may use to reference
// this transaction.

@property (nonatomic, readonly) NSData *paymentData;              // Contains payment data encrypted for the merchant
// using the symmetric key encapsulated in wrappedKey,
// according to the algorithm described by symmetricKeyInfo.

@end
