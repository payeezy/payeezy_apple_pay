//
//  QSRCustomer.m
//  FD_QSR_SDK_Demo


#import "QSRCustomer.h"

@implementation QSRCustomer

+ (QSRCustomer *)theCustomer
{
    static dispatch_once_t onceToken;
    static QSRCustomer *customer;
    dispatch_once(&onceToken, ^{
        customer = [[self alloc] init];
    });
    return customer;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self createCustomerParameters];
    }
    return self;
}

- (void)createCustomerParameters
{
    self.customerID = @"1";
    self.customerName = @"Jack Hardy";
}

@end
