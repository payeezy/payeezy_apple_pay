//
//  QSRCustomer.h
//  FD_QSR_SDK_Demo


#import <Foundation/Foundation.h>

@interface QSRCustomer : NSObject

@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *customerID;

+ (QSRCustomer *)theCustomer;

@end
