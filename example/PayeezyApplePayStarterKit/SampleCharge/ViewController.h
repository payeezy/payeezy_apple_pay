//
//  ViewController.h
//  SampleCharge
//
//  Created by First Data Corporation on 8/28/14.
//  Copyright (c) 2014 First Data Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <InAppSDK/FDPaymentAuthorizationViewControllerDelegate.h>

@interface ViewController : UIViewController <FDPaymentAuthorizationViewControllerDelegate>

@property (strong, nonatomic) UIAlertView* alert;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segPaymentType;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;

- (IBAction)payClicked:(id)sender;
@end

