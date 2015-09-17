//
//  QSROrderItemsViewController.m
//  FD_QSR_SDK_Demo
//


#import "QSROrderItemsViewController.h"
#import "QSROrderItem.h"
#import "QSROrderItemViewCell.h"
#import "QSROrder.h"
#import "QSRCustomer.h"
#import "TheDemoMerchant.h"

@interface QSROrderItemsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, QSROrderItemViewCellMenuDelegate>
{
    NSArray *unsortedList;
    NSMutableArray *sortedList;
    QSROrder *order;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *merchantLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpTimeTag;
@property (weak, nonatomic) IBOutlet UILabel *subTotalTag;
@property (weak, nonatomic) IBOutlet UILabel *taxTag;
@property (weak, nonatomic) IBOutlet UILabel *totalTag;

@end

@implementation QSROrderItemsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    order = [QSROrder theOrder];
    unsortedList = [QSROrderItem availableItems];
    self.merchantLabel.text = [[TheDemoMerchant soleInstance] merchantName];
    self.collectionView.delegate = self;
    [self.collectionView registerClass:QSROrderItemViewCell.class forCellWithReuseIdentifier:@"OrderCell"];
    UIMenuItem *deleteOneMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete One"
                                                               action:@selector(deleteOne:)];
    UIMenuItem *deleteAllOfMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete All These"
                                                                 action:@selector(deleteAllOf:)];
    UIMenuItem *deleteEverythingMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete Everything"
                                                                      action:@selector(deleteEverything:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[deleteOneMenuItem, deleteAllOfMenuItem, deleteEverythingMenuItem]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
    [self sortList];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshListAndTotals];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    //    NSLog(@"Observe change in keyPath: %@", keyPath);
    //    QSRCustomer *customer = [QSRCustomer theCustomer];
    //    NSLog(@"Change Detected in customer in store: %@", [[customer valueForKey:@"inStore"] boolValue] ? @"Yes" : @"No");
    [self refreshListAndTotals];
}


- (void)refreshListAndTotals
{
    NSString *dateString = [order scheduledPickupMessage];
    NSString *subTotalString = [order subTotalOfOrderAsCurrency];
    NSString *taxString = [order taxOnOrderAsCurrency];
    NSString *totalString = [order totalOfOrderAsCurrency];
    self.subTotalTag.text = subTotalString;
    self.pickUpTimeTag.text = dateString;
    self.taxTag.text = taxString;
    self.totalTag.text = totalString;
    [self.collectionView reloadData];
}

- (void)sortList
{
    // not sorted for now
    sortedList = [unsortedList mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger result = [sortedList count];
    return result;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 130);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QSROrderItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrderCell" forIndexPath:indexPath];
    QSROrderItem *item = sortedList[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", item.desc];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [item displayPriceAsCurrency]];
    cell.thumbnailView.image = [item thumbnailImage];
    QSROrder *theOrder = [QSROrder theOrder];
    NSUInteger matching = [theOrder numberOfItemsMatching:item];
    [cell updateBadgeWithCount:matching];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Not going to worry about changing an existing order
    QSROrderItem *item = sortedList[indexPath.row];
    [order addItem:item];
    [self refreshListAndTotals];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

// You have to implement all of the next 3 delegate methods if you implement any.
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    // The only menu response we are designed to handle is a delete request.
    // Check that there is an item ordered before we propose to put up a Delete menu.
    BOOL response = ([order hasItems]);
    return response;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    //    NSLog(@"%s SEL:%@", __PRETTY_FUNCTION__, NSStringFromSelector(action));
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - QSROrderItemViewCellMenuDelegate
- (BOOL)canPerformMenuAction:(SEL)action withSender:(id)sender forCell:(QSROrderItemViewCell *)cell
{
    if (action == @selector(deleteAllOf:) || action == @selector(deleteOne:))
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        QSROrderItem *item = sortedList[indexPath.row];
        NSUInteger matchCount = [order numberOfItemsWithSku:item.sku];
        if (matchCount == 1 && action == @selector(deleteOne:)) return YES;
        return (matchCount > 1);
    }
    if (action == @selector(deleteEverything:))
    {
        return YES;
    }
    return NO;
}

- (void)deleteOne:(id)sender forCell:(QSROrderItemViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    QSROrderItem *item = sortedList[indexPath.row];
    [order removeItem:item];
    [self refreshListAndTotals];
}

- (void)deleteAllOf:(id)sender forCell:(QSROrderItemViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    QSROrderItem *item = sortedList[indexPath.row];
    [order removeItemsMatching:item];
    [self refreshListAndTotals];
}

- (void)deleteEverything:(id)sender forCell:(QSROrderItemViewCell *)cell
{
    [order removeEverything];
    [self refreshListAndTotals];
}

#pragma mark - Ignored
- (void)deleteOne:(id)sender
{
}

- (void)deleteAllOf:(id)sender
{
}

- (void)deleteEverything:(id)sender
{
}

@end
