//
//  DataController.h
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    Vending_Refresh_Random=0,
    Vending_Refresh_Fixed,
};


@interface  DataTask:NSObject

@property (strong,nonatomic) NSConnection *connection;
@property (strong,nonatomic) NSData *responseData;

@end

//
// delegate object the receives notification about progress of getting random numbers
//
@protocol DataControllerDelegate <NSObject>

@optional

-(void)updatedFor:(NSString*)machineID;
-(void)refreshComplete;
@end

@interface DataController : NSObject <NSURLConnectionDelegate>

//holds machine name, id, average &  it's an array of dictionary
@property (strong,nonatomic) NSMutableArray *machines;
@property (assign,nonatomic) NSInteger refreshType;
@property (strong,nonatomic) NSMutableArray *randomNumbers;
@property (strong, nonatomic) NSMutableArray *average;

@property (weak,nonatomic) id <DataControllerDelegate> delegate;
@property (assign,atomic) BOOL syncing;
@property (strong,nonatomic) NSString *URL;


+(DataController*)sharedDataController;
+(NSString*)getImageForMachine:(NSString*)machineID;

// data object managment and ordering
-(NSInteger)count;
-(id)objectAtIndex:(NSInteger)index;
- (NSInteger)indexOfObject:(id)object;
-(void)removeObjectAtIndex:(NSInteger)index;
-(NSInteger)dataExist:(NSString*)machineID;
-(void)moveObjectFrom:(NSInteger)sourceRow to:(NSInteger)destinationRow;
-(BOOL)allowReorder;

//machine edit - NOT implemented
-(void)updateMachineName:(NSString*)newName for:(NSString*)machineID;
-(void)addMachine:(NSString*)name;



-(void)saveSettings;
-(void)loadSettings;

//
// Called to get new sets of random numbers
//
-(void)refresh;

@end
