//
//  QSROrderItemViewCell.m
//  FD_QSR_SDK_Demo


#import "QSROrderItemViewCell.h"
#import "QSROrder.h"

@implementation QSROrderItemViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageOffset = 6.0;
        CGFloat imageDoubleOffset = imageOffset * 2;
        CGFloat basicImageDimension = 100.0;
        self.thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOffset,
                                                                           imageOffset,
                                                                           (basicImageDimension - imageDoubleOffset),
                                                                           (basicImageDimension - imageDoubleOffset))];
        [self.contentView addSubview:self.thumbnailView];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 92, basicImageDimension, 12)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:10.0];
        [self.contentView addSubview:self.nameLabel];

        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 104, basicImageDimension, 12)];
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.textColor = [UIColor colorWithRed:0.0 green:81.0/256 blue:25.0/256 alpha:1.0];
        self.priceLabel.font = [UIFont systemFontOfSize:10.0];
        [self.contentView addSubview:self.priceLabel];

        self.selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
        self.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];

        CGFloat badgeDimension = 32.0;
        CGFloat xOffset = frame.size.width - badgeDimension - 2.0;
        CGFloat yOffset = 2.0;
        self.badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,
                                                                       yOffset,
                                                                       badgeDimension,
                                                                       badgeDimension)];
        [self.contentView addSubview:self.badgeView];
    }
    return self;
}

#pragma mark - Actions
- (void)updateBadgeWithCount:(NSUInteger)count
{
    if (count > 0)
    {
        if (!self.badge)
        {
            self.badge = [[QSRBadgeView alloc] initWithParentView:self.badgeView alignment:QSRBadgeViewAlignmentCenter];
            self.badge.badgeBackgroundColor = [UIColor colorWithRed: (176.0 / 256.0)
                                                              green: (227.0 / 256.0)
                                                               blue: (255.0 / 256.0)
                                                              alpha: 1.0];
        }
        self.badge.badgeText = [NSString stringWithFormat: @"%lu", (unsigned long)count];
    }
    else
    {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }
}

#pragma mark - Cell Delegate Methods
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    //    NSLog(@"%s in CELL.  Selector:%@", __PRETTY_FUNCTION__, NSStringFromSelector(action));
    return [self.delegate canPerformMenuAction:action withSender:sender forCell:self];
}

#pragma mark - Cell Delegate Actions
- (void)deleteEverything:(id)sender
{
    [self.delegate deleteEverything:sender forCell:self];
}

- (void)deleteAllOf:(id)sender
{
    [self.delegate deleteAllOf:sender forCell:self];
}

- (void)deleteOne:(id)sender
{
    [self.delegate deleteOne:sender forCell:self];
}

@end
