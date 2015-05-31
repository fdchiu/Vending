//
//  DataViewController.h
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//
// This same controller is used to show all vending machines
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UIView *machineImageView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *randomNumberSeq;

-(void)refresh;

@end

