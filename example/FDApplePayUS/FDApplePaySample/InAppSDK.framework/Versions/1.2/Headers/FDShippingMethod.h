//
//  FDShippingMethod.h
//  FDLibSDK
//
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDPaymentSummaryItem.h"

@interface FDShippingMethod : FDPaymentSummaryItem

@property (nonatomic, copy) NSString *identifier;     // Application-defined unique identifier for this shipping method.
                                                    // The application will receive this in paymentAuthorizationViewController:didAuthorizePayment:completion:.
@property (nonatomic, copy) NSString *detail;         // Additional localized information about the shipping method,
                                                    // for example “Ships in 24 Hours” or “Arrives Friday April 4”.

- (FDShippingMethod *)initWithIdentifier:(NSString *)identifier
                                  detail:(NSString *)detail
                                  amount:(NSDecimalNumber *)amount
                                   label:(NSString *)label;

@end
