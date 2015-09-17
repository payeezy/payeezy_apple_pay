//
//  QSRBadgeView.h
//  FD_QSR_SDK_Demo


#import <UIKit/UIKit.h>

typedef enum {
    QSRBadgeViewAlignmentTopLeft,
    QSRBadgeViewAlignmentTopRight,
    QSRBadgeViewAlignmentTopCenter,
    QSRBadgeViewAlignmentCenterLeft,
    QSRBadgeViewAlignmentCenterRight,
    QSRBadgeViewAlignmentBottomLeft,
    QSRBadgeViewAlignmentBottomRight,
    QSRBadgeViewAlignmentBottomCenter,
    QSRBadgeViewAlignmentCenter
} QSRBadgeViewAlignment;

@interface QSRBadgeView : UIView

@property (nonatomic, copy) NSString *badgeText;
@property (nonatomic, assign) QSRBadgeViewAlignment badgeAlignment;
@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, assign) CGSize badgeTextShadowOffset;
@property (nonatomic, strong) UIColor *badgeTextShadowColor;
@property (nonatomic, strong) UIFont *badgeTextFont;
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
@property (nonatomic, strong) UIColor *badgeOverlayColor;
@property (nonatomic, assign) CGPoint badgePositionAdjustment;
@property (nonatomic, assign) CGRect frameToPositionInRelationWith;

- (id)initWithParentView:(UIView *)parentView alignment:(QSRBadgeViewAlignment)alignment;

@end
