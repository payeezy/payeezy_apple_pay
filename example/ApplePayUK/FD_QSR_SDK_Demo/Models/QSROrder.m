//
//  QSROrder.m
//  FD_QSR_SDK_Demo


#import "QSROrder.h"
#import "QSROrderItem.h"
#import "TheDemoMerchant.h"
#import "QSRCustomer.h"

@interface QSROrder ()
{
    BOOL loadedFromStorage;
}
@end

@implementation QSROrder

+ (QSROrder *)theOrder
{
    static dispatch_once_t onceToken;
    static QSROrder *order;
    dispatch_once(&onceToken, ^{
        order = [[self alloc] init];
    });
    return order;
}

- (instancetype)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    _items = [@[] mutableCopy];
    _scheduledPickup = [[NSDate date] dateByAddingTimeInterval:60 * 60];
    _customerID = @"1";
    _customerName = @"";
    _subTotal = @0;
    _tax = @0;
    _totalOfOrder = @0;
    loadedFromStorage = NO;
    [self createShipToInfo];
    [self createBillingInfo];
    return self;
}

- (void)createShipToInfo
{
    // This is strictly for demo, hard coded

    NSString *shipToFirstName = @"Mia";
    NSString *shipToLastName = @"Wallace";
    NSString *shipToMobileNumber = @"555-123-4567";
    NSString *shipToStreet = @"231 E. Mehring Way";
    NSString *shipToCity = @"Coral Gables";
    NSString *shipToState = @"FL";
    NSString *shipToZip = @"33146";
    NSString *shipToCountry = @"United States";
    
    self.shipTo = ABPersonCreate();
    ABRecordSetValue(self.shipTo, kABPersonFirstNameProperty, (__bridge CFStringRef)shipToFirstName, nil);
    ABRecordSetValue(self.shipTo, kABPersonLastNameProperty, (__bridge CFStringRef)shipToLastName, nil);
    ABMutableMultiValueRef phoneRecord = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneRecord, (__bridge_retained CFStringRef)shipToMobileNumber, kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(self.shipTo, kABPersonPhoneProperty, phoneRecord, nil);
    CFRelease(phoneRecord);
    ABMutableMultiValueRef addressRecord = ABMultiValueCreateMutable(kABDictionaryPropertyType);
    CFStringRef dictionaryKeys[5];
    CFStringRef dictionaryValues[5];
    dictionaryKeys[0] = kABPersonAddressStreetKey;
    dictionaryKeys[1] = kABPersonAddressCityKey;
    dictionaryKeys[2] = kABPersonAddressStateKey;
    dictionaryKeys[3] = kABPersonAddressZIPKey;
    dictionaryKeys[4] = kABPersonAddressCountryKey;
    dictionaryValues[0] = (__bridge_retained CFStringRef)shipToStreet;
    dictionaryValues[1] = (__bridge_retained CFStringRef)shipToCity;
    dictionaryValues[2] = (__bridge_retained CFStringRef)shipToState;
    dictionaryValues[3] = (__bridge_retained CFStringRef)shipToZip;
    dictionaryValues[4] = (__bridge_retained CFStringRef)shipToCountry;
    CFDictionaryRef addressDictionary = CFDictionaryCreate(kCFAllocatorDefault,
                                                           (void *)dictionaryKeys,
                                                           (void *)dictionaryValues,
                                                           5,
                                                           &kCFCopyStringDictionaryKeyCallBacks,
                                                           &kCFTypeDictionaryValueCallBacks);
    ABMultiValueAddValueAndLabel(addressRecord, addressDictionary, kABHomeLabel, NULL);
    CFRelease(addressDictionary);
    ABRecordSetValue(self.shipTo, kABPersonAddressProperty, addressRecord, nil);
    CFRelease(addressRecord);
}

- (void)createBillingInfo
{
    // Do this for now;  Fill in alternate later.
    self.billingSameAsShipping = YES;
}

- (NSDictionary *)itemSkusAndQty
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (QSROrderItem *item in self.items)
    {
        NSString *itemKey = item.sku;
        if (![[dict allKeys] containsObject:itemKey])
        {
            dict[itemKey] = @0;
        }
        NSNumber *count = @([dict[itemKey] intValue] + 1);
        dict[itemKey] = count;
    }
    return [dict copy];
}

- (BOOL)orderHasItem:(QSROrderItem *)comparisonItem
{
    return ([self numberOfItemsMatching:comparisonItem] > 0);
}

- (BOOL)hasItems
{
    return ([self.items count] > 0);
}

- (NSUInteger)numberOfItemsMatching:(QSROrderItem *)item
{
    return [self numberOfItemsWithSku:item.sku];
}

- (NSUInteger)numberOfItemsWithSku:(NSString *)sku
{
    NSUInteger found = 0;
    for (QSROrderItem *item in self.items)
    {
        if ([item.sku isEqualToString:sku]) found++;
    }
    return found;
}

- (NSArray *)uniqueItems
{
    NSMutableArray *working = [@[] mutableCopy];
    NSMutableSet *skusSeen = [NSMutableSet set];
    for (QSROrderItem *item in self.items)
    {
        if (![skusSeen containsObject:item.sku])
        {
            [skusSeen addObject:item.sku];
            [working addObject:item];
        }
    }
    return [working copy];
}

- (void)addItem:(QSROrderItem *)item
{
    [self.items addObject:item];
    _totalOfOrder = @0;
    [self calculateTotals];
}

- (void)removeItem:(QSROrderItem *)item
{
    BOOL found = NO;
    NSInteger matchingIndex = 0;
    for (NSInteger index = 0; index < [self.items count]; index++)
    {
        QSROrderItem *checkedItem = self.items[index];
        if ([checkedItem.sku isEqualToString:item.sku])
        {
            found = YES;
            matchingIndex = index;
            break;
        }
    }
    if (found)
    {
        [self.items removeObjectAtIndex:matchingIndex];
        _totalOfOrder = @0;
        [self calculateTotals];
    }
}

- (void)removeItemsMatching:(QSROrderItem *)item
{
    [self.items removeObject:item];
    _totalOfOrder = @0;
    [self calculateTotals];
}

- (void)removeEverything
{
    [self.items removeAllObjects];
    _totalOfOrder = @0;
    [self calculateTotals];
}

- (NSString *)description
{
    NSMutableString *result = [NSMutableString new];
    [result appendString:[NSString stringWithFormat:@"Customer: %@ Order Size:%lu\n", self.customerName, (unsigned long)[self.items count]]];
    for (NSInteger idx = 0; idx < [self.items count]; idx++)
    {
        QSROrderItem *item = self.items[idx];
        [result appendString:[NSString stringWithFormat:@"%@", [item description]]];
    }
    [result appendString:[NSString stringWithFormat:@"\nSubtotal:%@\n", [self subTotalOfOrderAsCurrency]]];
    [result appendString:[NSString stringWithFormat:@"Tax:%@\n", [self taxOnOrderAsCurrency]]];
    [result appendString:[NSString stringWithFormat:@"Total:%@", [self totalOfOrderAsCurrency]]];
    return [result copy];
}

- (NSArray *)fdSummaryItemsWithTotalFromMerchant:(TheDemoMerchant *)merchant
{
    NSMutableArray *fdSummaryItems = [@[] mutableCopy];
    int runningSubtotalInPennies = 0;
    for (QSROrderItem *item in self.items)
    {
        runningSubtotalInPennies = runningSubtotalInPennies + [item.priceInPennies intValue];

        NSDecimalNumber *totalUSD = [NSDecimalNumber decimalNumberWithDecimal:[item.priceInPennies decimalValue]];
        FDPaymentSummaryItem *fdItem = [FDPaymentSummaryItem summaryItemWithLabel:item.desc amount:[totalUSD decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithFloat:100.0f]]];

        [fdSummaryItems addObject:fdItem];
    }
    int taxInPennies = (int)(runningSubtotalInPennies * [merchant taxRate]);

    NSDecimalNumber *subTotalOfItems = [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", runningSubtotalInPennies]] decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithFloat:100.0f]];
    NSDecimalNumber *taxOnItems = [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", taxInPennies]] decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithFloat:100.0f]];

    NSDecimalNumber *totalOfItems = [subTotalOfItems decimalNumberByAdding:taxOnItems];
    
    FDPaymentSummaryItem *taxItem = [FDPaymentSummaryItem summaryItemWithLabel:@"Sales Tax" amount:taxOnItems];
    [fdSummaryItems addObject:taxItem];
    
    FDPaymentSummaryItem *totalItem = [FDPaymentSummaryItem summaryItemWithLabel:merchant.merchantName amount:totalOfItems];
    [fdSummaryItems addObject:totalItem];
    return [fdSummaryItems copy];
}

- (void)calculateTotals
{
    if ([_totalOfOrder isEqualToValue:@0])
    {
        int runningSubtotalInPennies = 0;
        for (QSROrderItem *item in self.items)
        {
            runningSubtotalInPennies = runningSubtotalInPennies + [item.priceInPennies intValue];
        }
        int taxInPennies = (int)(runningSubtotalInPennies * [[TheDemoMerchant soleInstance] taxRate]);
        int runningTotalInPennies = runningSubtotalInPennies + taxInPennies;
        _subTotal = [NSNumber numberWithInt:runningSubtotalInPennies];
        _tax = [NSNumber numberWithInt:taxInPennies];
        _totalOfOrder = [NSNumber numberWithInt:runningTotalInPennies];
    }
}

- (NSString *)taxOnOrderAsCurrency
{
    [self calculateTotals];
    return [TheDemoMerchant displayAsCurrency:([self.tax intValue] / 100.0)];
}

- (NSString *)subTotalOfOrderAsCurrency
{
    [self calculateTotals];
    return [TheDemoMerchant displayAsCurrency:([self.subTotal intValue] / 100.0)];
}

- (NSString *)totalOfOrderAsCurrency
{
    [self calculateTotals];
    return [TheDemoMerchant displayAsCurrency:([self.totalOfOrder intValue] / 100.0)];
}

- (void)deleteOrder
{
    [self.items removeAllObjects];
    _totalOfOrder = @0;
    [self calculateTotals];
  //  [NSUserDefaults resetStandardUserDefaults];  // JTE 9/7
    loadedFromStorage = NO;
}

- (NSString *)scheduledPickupMessage
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E - MMMM dd, hh:MM a"];
    NSString *dateString = [formatter stringFromDate:[self scheduledPickup]];
    return dateString;
}

- (NSMutableAttributedString *)orderReportForCustomer:(QSRCustomer *)aCustomer
{
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] init];
    NSString *customerNameString = aCustomer.customerName;
    NSString *customerString = (![customerNameString isEqualToString:@""]) ? [NSString stringWithFormat:@"Customer: %@\n\n", customerNameString] : @"";
    NSString *itemString;
    NSString *descString;
    NSUInteger qtyOfItem;
    NSMutableAttributedString *attString;
    attString = [[NSMutableAttributedString alloc] initWithString:customerString];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]
                      range:NSMakeRange(0, [customerString length])];
    [mutableAttString appendAttributedString:attString];
    for (QSROrderItem *item in [self uniqueItems])
    {
        qtyOfItem = [self numberOfItemsWithSku:item.sku];
        descString = item.desc;
        itemString = [NSString stringWithFormat:@"%li %@\n", (unsigned long)qtyOfItem, descString];
        attString = [[NSMutableAttributedString alloc] initWithString:itemString];
        [mutableAttString appendAttributedString:attString];
    }
    NSString *subTotalString = [NSString stringWithFormat:@"\nSub Total: %@\n", [self subTotalOfOrderAsCurrency]];
    NSString *taxString = [NSString stringWithFormat:@"Tax: %@\n", [self taxOnOrderAsCurrency]];
    NSString *totalString = [NSString stringWithFormat:@"Total: %@\n", [self totalOfOrderAsCurrency]];
    attString = [[NSMutableAttributedString alloc] initWithString:subTotalString];
    [mutableAttString appendAttributedString:attString];
    attString = [[NSMutableAttributedString alloc] initWithString:taxString];
    [mutableAttString appendAttributedString:attString];
    attString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]
                      range:NSMakeRange(0, [totalString length])];
    [mutableAttString appendAttributedString:attString];
    return mutableAttString;
}

- (NSMutableAttributedString *)orderShippingReportForCustomer:(QSRCustomer *)aCustomer
{
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] init];
    NSString *customerNameString = aCustomer.customerName;
    NSString *customerString = (![customerNameString isEqualToString:@""]) ? [NSString stringWithFormat:@"Customer: %@\n\n", customerNameString] : @"";
    NSMutableAttributedString *attString;
    attString = [[NSMutableAttributedString alloc] initWithString:customerString];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]
                      range:NSMakeRange(0, [customerString length])];
    [mutableAttString appendAttributedString:attString];
    NSString *label = @"Ship To:\n";
    attString = [[NSMutableAttributedString alloc] initWithString:label];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]
                      range:NSMakeRange(0, [label length])];
    [mutableAttString appendAttributedString:attString];
    NSString *shipToFirstName = (__bridge_transfer NSString *)ABRecordCopyValue(self.shipTo, kABPersonFirstNameProperty);
    NSString *shipToLastName = (__bridge_transfer NSString *)ABRecordCopyValue(self.shipTo, kABPersonLastNameProperty);
    NSString *shipToName = [NSString stringWithFormat:@"    %@ %@\n", shipToFirstName, shipToLastName];
    attString = [[NSMutableAttributedString alloc] initWithString:shipToName];
    [mutableAttString appendAttributedString:attString];
    ABMultiValueRef phoneRecord = ABRecordCopyValue(self.shipTo, kABPersonPhoneProperty);
    CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phoneRecord, 0);
    NSString *mobileNumber = (__bridge_transfer NSString *)phoneNumber;
    CFRelease(phoneRecord);
    attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@\n", mobileNumber]];
    [mutableAttString appendAttributedString:attString];
    ABMultiValueRef addressRecord = ABRecordCopyValue(self.shipTo, kABPersonAddressProperty);
    if (ABMultiValueGetCount(addressRecord) > 0) {
        CFDictionaryRef addressDictionary = ABMultiValueCopyValueAtIndex(addressRecord, 0);
        NSString *shipToStreet = [NSString stringWithString:(__bridge NSString *)CFDictionaryGetValue(addressDictionary, kABPersonAddressStreetKey)];
        NSString *shipToCity = [NSString stringWithString:(__bridge NSString *)CFDictionaryGetValue(addressDictionary, kABPersonAddressCityKey)];
        NSString *shipToState = [NSString stringWithString:(__bridge NSString *)CFDictionaryGetValue(addressDictionary, kABPersonAddressStateKey)];
        NSString *shipToZip = [NSString stringWithString:(__bridge NSString *)CFDictionaryGetValue(addressDictionary, kABPersonAddressZIPKey)];
        NSString *shipToCountry = [NSString stringWithString:(__bridge NSString *)CFDictionaryGetValue(addressDictionary, kABPersonAddressCountryKey)];
        NSString *cityStateZip = [NSString stringWithFormat:@"%@, %@ %@", shipToCity, shipToState, shipToZip];
        attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@\n", shipToStreet]];
        [mutableAttString appendAttributedString:attString];
        attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@\n", cityStateZip]];
        [mutableAttString appendAttributedString:attString];
        attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@\n", shipToCountry]];
        [mutableAttString appendAttributedString:attString];
        CFRelease(addressDictionary);
    }
    CFRelease(addressRecord);
    return mutableAttString;
}

#pragma mark - persistence

- (void)savePersistentData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.customerID forKey:@"customerID"];
    [userDefaults setObject:self.customerName forKey:@"customerName"];
    [userDefaults setObject:[NSNumber numberWithInteger:[self.items count]] forKey:@"numberOfItems"];
    for (NSInteger index = 0; index < [self.items count]; index++)
    {
        NSString *key = [NSString stringWithFormat:@"%03liSKU", (long)index];
        QSROrderItem *item = self.items[index];
        NSString *value = item.sku;
        [userDefaults setObject:value forKey:key];
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    NSString *pickupDateString = [formatter stringFromDate:self.scheduledPickup];
    [userDefaults setObject:pickupDateString forKey:@"scheduledPickup"];
    [userDefaults synchronize];
}

- (void)loadPersistentData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Check the first value if it is loaded or not (assumption is these are nil if not previously set and it they are not nil we should not override them.
    if (!loadedFromStorage)
    {
        NSString *valueFromStorage = [userDefaults objectForKey:@"customerID"];
        if (valueFromStorage)   // If we have no stored data we skip loading details (and overloading our initialized values).
        {
            self.customerID = valueFromStorage;
            self.customerName = [userDefaults objectForKey:@"customerName"];
            if (!self.customerName) self.customerName = @"";
            [self.items removeAllObjects];
            NSInteger howMany = [[userDefaults objectForKey:@"numberOfItems"] integerValue];
            for (NSInteger index = 0; index < howMany; index++)
            {
                NSString *key = [NSString stringWithFormat:@"%03liSKU", (long)index];
                NSString *sku = [userDefaults objectForKey:key];
                QSROrderItem *item = [QSROrderItem availableItemWithSku:sku];
                [self addItem:item];
            }
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            NSString *pickupDateString = [userDefaults objectForKey:@"scheduledPickup"];
            [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
            self.scheduledPickup = [formatter dateFromString:pickupDateString];
            [self calculateTotals];
        }
        loadedFromStorage = YES;
    }
}

@end
