//
//  FDPaymentResponse.h
//  FDLibSDK
//
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDPaymentDefs.h"

@interface FDPaymentResponse : NSObject


+ (FDPaymentResponse* )responseWithDictionary:(NSDictionary*)dictionary;
- (FDPaymentResponse *)initWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic,readonly) NSDictionary* cardInfo;                      // Credit card info used to process the trancation

@property (nonatomic,readonly) NSString* totalAmount;                       // Transaction Amount charged on card including shipping + tax if applicable

@property (nonatomic,readonly) NSString* transactionID;                     // Transaction ID for merchant to use to capture / void / return trasaction via FirstData

@property (nonatomic,readonly) NSString* transactionType;                   // Transaction Type - authorize / purchase

@property (nonatomic,readonly) NSString* transactionTag;                    // Transaction Tag

@property (nonatomic,readonly) NSString* transStatusMessage;                // Transaction authorization status message

@property (nonatomic,readonly) NSString* transarmorToken;                     // Transarmor Token

//@property FDPaymentResponseError* errorStatus;                              //error status

//@property (nonatomic,readonly) NSError* errorMessage;                      // Success or failure

@property (nonatomic, assign) FDPaymentAuthorizationStatus authStatus;
@property (nonatomic, assign) FDPaymentValidationStatus validationStatus;

@property (nonatomic, assign) FDPaymentType paymentType;                    // Pre-auth only or purchase

@end
