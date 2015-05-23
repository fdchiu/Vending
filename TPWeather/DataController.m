//
//  DataController.m
//  TPWeather
//
//  Created by David on 5/23/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import "DataController.h"

@implementation DataController
-(instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
        _zipcodes = [[NSMutableArray alloc] init];
        _refreshType = TPWeather_Refresh_Sequencial;
    }
    return self;
}


-(NSInteger)count
{
    return [self.zipcodes count];
}
-(id)objectAtIndex:(NSInteger)index
{
    return [self.zipcodes objectAtIndex:index];
}

@end
