//
//  ModelController.h
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//
//   Controls the modal of vending machines
//

#import <UIKit/UIKit.h>

@class DataViewController;
@class DataController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>
@property (readonly,strong,nonatomic) DataController *dataController;

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

