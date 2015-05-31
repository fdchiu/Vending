//
//  RootViewController.h
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate,DataControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

