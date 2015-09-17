//
//  QSROrderItem.h
//  FD_QSR_SDK_Demo


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QSROrderItem : NSObject

@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *priceInPennies;
@property (nonatomic, strong) NSString *thumbnailID;

+ (NSArray *)availableItems;
+ (QSROrderItem *)initWithSku:(NSString *)skuString name:(NSString *)desc cost:(NSNumber *)cost thumbnail:(NSString *)thumb;
+ (QSROrderItem *)availableItemWithSku:(NSString *)skuString;
- (UIImage *)thumbnailImage;
- (NSString *)displayPriceAsCurrency;
- (NSString *)displayPrice;

@end
