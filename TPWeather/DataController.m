//
//  DataController.m
//  TPWeather
//
//  Created by David on 5/23/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import "DataController.h"

@implementation DataController

+(DataController*)sharedDataController{
    
    static DataController *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    if(!sharedInstance)
        dispatch_once(&oncePredecate,^{
            sharedInstance=[[DataController alloc] init];
        
        });
    return sharedInstance;
}


+(NSString*)getImageForWeather:(NSString*)weatherString
{
    return [[DataController sharedDataController] getImageName:weatherString];
}

-(NSString*)getImageName:(NSString*)weatherString
{
 
    NSString *imagename=[self.weatherImage objectForKey:weatherString];
    if(!imagename)
        return [self.weatherImage objectForKey:@"Fair"];
    
    return imagename;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
        _zipcodes = [[NSMutableArray alloc] init];
        [self loadSettings];
        if([_zipcodes count] ==0) { //no data; add default
            _refreshType = TPWeather_Refresh_Sequencial;
            NSDictionary *dic=@{@"zipcode":@"95014", @"weather":@"Sunny",@"temperature":@"65"};
            [_zipcodes addObject:dic];
        }
        _weatherImage=@{@"Sunny":@"sunny",@"Cloudy":@"cloudy",@"Raining":@"rainy",@"Fair":@"fair"};
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

- (NSInteger)indexOfObject:(id)object
{
    return [self.zipcodes indexOfObject:object];
}

-(BOOL)dataExist:(NSString*)zipcode
{
    for (NSDictionary *dic in self.zipcodes) {
        NSString *tempString=[NSString stringWithUTF8String:[[dic valueForKey:@"zipcode"] UTF8String]];
        if([tempString isEqualToString:[NSString stringWithUTF8String:[zipcode UTF8String]]])
            return TRUE;
    }
    return FALSE;
}

-(void)addZipcode:(NSString*)zipcode
{
    if([self dataExist:zipcode])
        return;
    
    [self.zipcodes addObject:@{@"zipcode":zipcode,@"weather":@"Sunny",@"temperature":@"65"}];
    
    [self saveSettings];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getWeatherForZipcode:zipcode];
    });
}

-(void)getWeatherForZipcode:(NSString*)zipcode
{
    NSLog(@"Getting weather data for zipcode: %@", zipcode);
    
}

-(void)saveSettings
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.zipcodes forKey:@"zipcode"];
    [defaults setInteger:self.refreshType forKey:@"refresh type"];
    
    [defaults synchronize];

}

-(void)loadSettings
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [self.zipcodes addObjectsFromArray:[defaults objectForKey:@"zipcode"]];
    self.refreshType = [defaults  integerForKey:@"refresh type"];
    
}
@end
