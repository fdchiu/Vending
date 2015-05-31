//
//  AppDelegate.h
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendingSetup: NSObject
@property (strong,nonatomic) NSMutableArray *zipcode;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

