//
//  QSROrderItemViewCell.h
//  FD_QSR_SDK_Demo


#import "QSRBadgeView.h"

@class QSROrderItemViewCell;

@protocol QSROrderItemViewCellMenuDelegate <NSObject>
- (void)deleteOne:(id)sender forCell:(QSROrderItemViewCell *)cell;
- (void)deleteAllOf:(id)sender forCell:(QSROrderItemViewCell *)cell;
- (void)deleteEverything:(id)sender forCell:(QSROrderItemViewCell *)cell;
- (BOOL)canPerformMenuAction:(SEL)action withSender:(id)sender forCell:(QSROrderItemViewCell *)cell;
@end

@interface QSROrderItemViewCell : UICollectionViewCell

@property (nonatomic, weak) id<QSROrderItemViewCellMenuDelegate> delegate;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIImageView *thumbnailView;
@property (strong, nonatomic) UIImageView *badgeView;
@property (strong, nonatomic) QSRBadgeView *badge;

- (void)updateBadgeWithCount:(NSUInteger)count;

@end
