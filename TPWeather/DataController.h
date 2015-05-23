//
//  DataController.h
//  TPWeather
//
//  Created by David on 5/23/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    TPWeather_Refresh_Sequencial=0,
    TPWeather_Refresh_Concurrent,
};

@interface DataController : NSObject
@property (strong,nonatomic) NSMutableArray *zipcodes;
@property (assign,nonatomic) NSInteger *refreshType;


-(NSInteger)count;
-(id)objectAtIndex:(NSInteger)index;

@end
