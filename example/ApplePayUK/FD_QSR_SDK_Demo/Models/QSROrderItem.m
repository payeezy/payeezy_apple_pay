//
//  QSROrderItem.m
//  FD_QSR_SDK_Demo


#import "QSROrderItem.h"
#import "TheDemoMerchant.h"

@interface QSROrderItem ()
{
    UIImage *thumbnail;
}
@end

@implementation QSROrderItem

+ (NSArray *)dataList
{
    return @[ // SKU, Description, Pennies, Thumbnail
             @[@"1002-HBG", @"Hamburger", @1199, @"burger"],
             @[@"1001-DBH", @"Double Hamburger", @1299, @"doubleBurger"],
             @[@"1000-CHB", @"Cheese Burger", @1129, @"cheeseburger"],
             @[@"1010-DBC", @"Double Cheese Burger", @1299, @"doubleCheeseBurger"],
             @[@"1500-FRI", @"Triple Cooked Chips", @289, @"fries"],
             @[@"1520-ONR", @"Onion Rings", @249, @"onionRings"],
             @[@"2000-COF", @"Cup Coffee", @75, @"coffee"],
             @[@"3000-SLD", @"House Salad", @650, @"sideSalad"],
             @[@"4000-CKE", @"Root Beer", @100, @"rootBeer"],
             @[@"4050-VAN", @"Vanilla Shake", @150, @"vanillaShake"],
             ];
}

+ (QSROrderItem *)initWithSku:(NSString *)skuString name:(NSString *)desc cost:(NSNumber *)cost thumbnail:(NSString *)thumb
{
    QSROrderItem *item = [[QSROrderItem alloc] init];
    item.sku = skuString;
    item.desc = desc;
    item.priceInPennies = cost;
    item.thumbnailID = thumb;
    return item;
}

+ (NSArray *)availableItems
{
    NSMutableArray *items = [@[] mutableCopy];
    for (NSArray *dataArray in [self dataList])
    {
        [items addObject:[QSROrderItem initWithSku:dataArray[0] name:dataArray[1] cost:dataArray[2] thumbnail:dataArray[3]]];
    }
    return [items copy];
}

+ (QSROrderItem *)availableItemWithSku:(NSString *)skuString
{
    NSArray *available = [self availableItems];
    NSUInteger idx = [available indexOfObjectPassingTest: ^ BOOL (QSROrderItem* obj, NSUInteger idx, BOOL *stop)
                      {
                          return [obj.sku isEqualToString:skuString];
                      }];
    return available[idx];
}

- (NSUInteger)hash
{
    return [self.sku hash];
}

-(BOOL)isEqual:(QSROrderItem *)item
{
    return [self.sku isEqualToString:item.sku];
}

- (UIImage *)thumbnailImage
{
    if (!thumbnail)
    {
        thumbnail = [UIImage imageNamed:self.thumbnailID];
    }
    return thumbnail;
}

- (NSString *)displayPriceAsCurrency
{
    return [TheDemoMerchant displayAsCurrency:([self.priceInPennies intValue] / 100.0)];
}

- (NSString *)displayPrice
{
    return [NSString stringWithFormat:@"%.2f", [self.priceInPennies intValue] / 100.0];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nSKU:%@\nNAME:%@\nPRICE:%@\n", self.sku, self.desc, [self displayPriceAsCurrency]];
}

@end
