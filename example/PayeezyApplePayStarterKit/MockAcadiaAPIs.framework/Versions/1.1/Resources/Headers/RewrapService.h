//
//  RewrapService.h
//  MockAcadiaAPIs
//
//  Created by Vamsi on 7/22/14.
//  Copyright (c) 2014 FirstData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewrapService : NSObject <NSURLConnectionDelegate>

+ (void)initWithAPIKey:(NSString *)apiKey secret:(NSString *)apiSecret token:(NSString *)token;

+ (NSDictionary*)makePayloadUsing3DSFakeServiceForMerchantIdentifier:(NSString*)mid
                                                 paymentSymmaryItems:(NSArray*)paymentSummaryItems
                                                        currencyCode:(NSString*)currencyCode
                                                     applicationData:(NSData*)applicationData;

+ (void)generateAFakePayload:(NSDictionary *)payload
                  completion:(void (^)(NSData *, NSError *))completion;

@end
