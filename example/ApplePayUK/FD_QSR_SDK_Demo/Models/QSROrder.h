//
//  QSROrder.h
//  FD_QSR_SDK_Demo


#import <Foundation/Foundation.h>
#import <InAppSDK/InAppSDK.h>
#import "TheDemoMerchant.h"

@class QSRCustomer;
@class QSROrderItem;

@import AddressBook;

@interface QSROrder : NSObject

@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSDate *scheduledPickup;
@property (nonatomic, strong) NSNumber *subTotal;
@property (nonatomic, strong) NSNumber *tax;
@property (nonatomic, strong) NSNumber *totalOfOrder;
@property (nonatomic, assign) ABRecordRef shipTo;
@property (nonatomic, assign) ABRecordRef billingAddress;
@property (nonatomic, assign) BOOL billingSameAsShipping;

+ (QSROrder *)theOrder;
- (BOOL)hasItems;
- (BOOL)orderHasItem:(QSROrderItem *)item;
- (void)addItem:(QSROrderItem *)item;
- (void)removeItem:(QSROrderItem *)item;
- (void)removeItemsMatching:(QSROrderItem *)item;
- (void)removeEverything;
- (NSUInteger)numberOfItemsMatching:(QSROrderItem *)item;
- (NSUInteger)numberOfItemsWithSku:(NSString *)sku;
- (NSString *)description;
- (NSString *)totalOfOrderAsCurrency;
- (NSString *)taxOnOrderAsCurrency;
- (NSString *)subTotalOfOrderAsCurrency;
- (void)savePersistentData;
- (void)loadPersistentData;
- (void)deleteOrder;
- (NSString *)scheduledPickupMessage;
- (NSArray *)uniqueItems;
- (NSDictionary *)itemSkusAndQty;
- (NSMutableAttributedString *)orderReportForCustomer:(QSRCustomer *)aCustomer;
- (NSMutableAttributedString *)orderShippingReportForCustomer:(QSRCustomer *)aCustomer;
- (NSArray *)fdSummaryItemsWithTotalFromMerchant:(TheDemoMerchant *)merchant;

@end
