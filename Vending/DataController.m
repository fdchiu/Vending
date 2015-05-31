//
//  DataController.m
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//
//  This calls handles and supplies all data (random number, orders)
//  It works with ModalController to complete MVC design pattern
//
#import <UIKit/UIKit.h>
#import "DataController.h"

#define PREDEFINED_MAX_COUNT 15

@interface DataController() {
    NSTimer *startSyncTimer;
    NSInteger loopCounter;
    NSMutableArray *orders;
}
@property (assign,atomic) NSInteger nextIndex;   //save next machine index when trying to get random number for it
@property (strong,atomic) NSMutableArray *taskQueue; // used to keep tracking the tasks that is used to get random numbers

@end

@implementation DataController
@synthesize randomNumbers,average;

// singleton class
+(DataController*)sharedDataController{
    
    static DataController *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    if(!sharedInstance)
        dispatch_once(&oncePredecate,^{
            sharedInstance=[[DataController alloc] init];
        
        });
    return sharedInstance;
}


+(NSString*)getImageForMachine:(NSString*)machineID
{
    return [[DataController sharedDataController] getImageName:machineID];
}

//
// initialization of the data object
//
-(instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
        _machines = [[NSMutableArray alloc] init];
        NSArray *random=@[@70,@70,@70];

        // machines are saved to persistent memory
        [self loadSettings];
        if([_machines count] ==0) { //no data saved previously; add default
            _refreshType = Vending_Refresh_Random;
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:@{@"id":@"0", @"machine":@"New Brand Machine",@"average":@"70"}];
            [_machines addObject:dic];
            dic=[NSMutableDictionary dictionaryWithDictionary: @{@"id":@"1", @"machine":@"Red Coke Machine",@"average":@"70"}];
                 [_machines addObject:dic];

            dic=[NSMutableDictionary dictionaryWithDictionary: @{@"id":@"2", @"machine":@"Sandwidge Machine",@"average":@"70"}];
            [_machines addObject:dic];
            dic=[NSMutableDictionary dictionaryWithDictionary: @{@"id":@"3", @"machine":@"Hot Dog Machine",@"average":@"70"}];
            [_machines addObject:dic];
            dic=[NSMutableDictionary dictionaryWithDictionary: @{@"id":@"4", @"machine":@"Snack Machine",@"average":@"70"}];
            [_machines addObject:dic];
        }
        
        // orders and random numbers are restarted with every run since we need to get new sets of random numbers & re-establish orders anyway
        orders = [[NSMutableArray alloc] init];
        self.URL = @"https://www.random.org/integers/?num=1&min=70&max=90&col=1&base=10&format=plain&rnd=new";
        randomNumbers = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[_machines count]; i++) {
            randomNumbers[i] = [[NSMutableArray alloc] init];
            [_machines[i] setObject:random forKey:@"random"];
            [orders addObject:[NSDictionary dictionaryWithObjectsAndKeys:@70,@"average",[NSNumber numberWithInt:i],@"machineID",nil]];
        }
        average = [NSMutableArray arrayWithArray:@[@70,@70,@70,@70,@70]];
        _taskQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - image method
-(NSString*)getImageName:(NSString*)machineID
{
    return [NSString stringWithFormat:@"vending%@",machineID];
}


#pragma mark - data object managment
-(void)removeObjectAtIndex:(NSInteger)index
{
    if(index>=0 && index<[self.machines count])
        [self.machines removeObjectAtIndex:index];
}

-(NSInteger)count
{
    return [self.machines count];
}

// the index is actually order
-(id)objectAtIndex:(NSInteger)index
{
    //return [self.machines objectAtIndex:index];
    NSInteger objectIndex=[[orders[index] valueForKey:@"machineID"] integerValue];
    return [self.machines objectAtIndex:objectIndex];
}

//order of the object
- (NSInteger)indexOfObject:(id)object
{
    NSInteger index= [self.machines indexOfObject:object];
    NSInteger i;
    for ( i=0; i< [orders count];i++) {
        NSInteger machineID = [[orders[i] valueForKey:@"machineID"] integerValue];
        if(machineID == index)
            break;
    }
    return i;
}

//
// check whether a machine exists or not
//
-(NSInteger)dataExist:(NSString*)machineID
{
    NSInteger i=[machineID integerValue];
    if(i<0 || i>=[self.machines count])
        return NSNotFound;
    return i;
}

//
// Get the order of the machine
//
-(NSInteger)findOrderForMachine:(NSString*)machineID
{
    NSInteger index=[self dataExist:machineID];
    if(index == NSNotFound)
        return NSNotFound;
    
    NSInteger i;
    for ( i=0;i<[orders count];  i++) {
        NSInteger machineID = [[orders[i] valueForKey:@"machineID"] integerValue];
        if(machineID == index)
            break;
    }
    return i;
}

//
// Support adjusting order of machines when "Fixed" is set in settings
//
-(void)moveObjectFrom:(NSInteger)sourceRow to:(NSInteger)destinationRow
{
    if (sourceRow<0 || destinationRow <0 || sourceRow >[self.machines count] || destinationRow >[self.machines count]) {
        return;
    }
    NSDictionary *temp=orders[sourceRow];
    [orders replaceObjectAtIndex:sourceRow withObject:orders[destinationRow]];
    [orders replaceObjectAtIndex:destinationRow withObject:temp];
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(refreshComplete)])
            [self.delegate performSelector:@selector(refreshComplete)];

}

//
// Only when in "Fixed" mode machine order can be adjusted and reordered by user
//
-(BOOL)allowReorder
{
    return (self.refreshType==Vending_Refresh_Fixed);
}

#pragma mark - persistency
-(void)saveSettings
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.machines forKey:@"machines"];
    [defaults setInteger:self.refreshType forKey:@"refresh type"];
    
    [defaults synchronize];

}

-(void)loadSettings
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.refreshType = [defaults  integerForKey:@"refresh type"];

    NSArray *loaded = [defaults objectForKey:@"machines"];
    for (int i=0; i<[loaded count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:loaded[i]];
        self.machines[i]=dic;
    }
    
}

//
// Entry point to get new sets of random numbers
//
-(void)refresh
{
    for(int i=0;i<[randomNumbers count];i++)
        [randomNumbers[i] removeAllObjects];
    [self startSync];
}

//
// Get random number for a given machine
// Each task is queue in taskQueue
// NSURLConnection is used to acquire numbers
//
-(void)getNumberFor:(NSInteger)index
{
    NSLog(@"Get data for machine: %ld", index);
    
    // Create the request.
    NSURLRequest *request;
    
    // Create url connection and fire requests. 3 requests are sent. URL is appended with a number so all
    // 3 requests have different URL to avoid caching
    //
    NSURLConnection *conn;
    for(int i=0;i<3;i++) {
        request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&seq=%d",self.URL,i]]];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:@{@"connection":conn,@"data":[NSNull null],@"id":[NSNumber numberWithInteger:index],@"sequence":[NSNumber numberWithInt:i]}];
        [self.taskQueue addObject:dic];
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    NSMutableDictionary *dic=[self findTaskForConnection:connection];
    if(dic) {
        [dic setObject:[[NSMutableData alloc] init] forKey:@"data"];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    
    NSDictionary *task = [self findTaskForConnection:connection];
    if(task) 
        [[task valueForKey:@"data"] appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
   
    NSDictionary *task=[self findTaskForConnection:connection];
    
    if(task) {
        [self parseResponseForTask:task];
        [self handleNext:task];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Error: %@",error);
    NSDictionary *task=[self findTaskForConnection:connection];
    if(task)
        [self handleNext:task];
}

//
// Parse response coming back from web site
//
-(void)parseResponseForTask:(NSDictionary*)task
{
    //NSURLConnection *connection=[task valueForKey:@"connection"];
    NSLog(@"Parsing received data:");
    NSString *response=[[NSString alloc] initWithData:[task valueForKey:@"data"] encoding:NSUTF8StringEncoding];
    NSNumber *index=[task valueForKey:@"id"];
    NSNumber *sequence=[task valueForKey:@"sequence"];
    
    int num = [response intValue];
    
    [randomNumbers[[index intValue]] addObject:[NSNumber numberWithInt:num]];
    NSLog(@"Received Number: %d for sequence:%@",num,sequence);
}

#pragma mark - syncing
-(void)startSync
{
    // if a syncing is going on we will wait until it's done.
    // if because of network issu syncing stuck after a time out, all tak will be cancelled
    if(self.syncing) {
        NSLog(@"Previous syncing not completed yet. Waite");
        startSyncTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(syncChecking) userInfo:nil repeats:NO];
        return;
    }
    self.syncing = TRUE;
    NSLog(@"Sync  data. Syncing: %ld", self.nextIndex);
    [self getNumberFor:self.nextIndex];
}

-(void)syncChecking
{
    if(!self.syncing)
        loopCounter=0;
    else {
        loopCounter++;
        if(loopCounter>PREDEFINED_MAX_COUNT) { // current syncing cannot finish, clear the queue
            [self.taskQueue removeAllObjects];
            self.syncing = FALSE;
            loopCounter =0;
            NSLog(@"Time out. Clear all task");
        }
    }
    [self startSync];
}


#pragma mark - task queue
-(NSMutableDictionary*)findTaskForConnection:(id)connection
    {
        for(NSMutableDictionary *dic in self.taskQueue)
            if([dic objectForKey:@"connection"] == connection)
                return dic;
        return nil;
    }

//
// Called after one random number is received
//
-(void)handleNext:(NSDictionary*)task
{

    [self.taskQueue removeObject:task];
    NSNumber *index = [task valueForKey:@"id"];
    int i=[index intValue];
    if ([randomNumbers[[index intValue]] count]<3) {  // Not all 3 random numbers have been received yet.
        return;
    }
    
    // All 3 random numbers received; Now calculate the average and save the data
    int average0 = (int)(([randomNumbers[i][0] floatValue]+[randomNumbers[i][1] floatValue]+[randomNumbers[i][2] floatValue])/3.0);
    [self.machines[i] setObject:[NSString stringWithFormat:@"%d",average0] forKey:@"average"];
    [self.machines[[index intValue]] setObject:randomNumbers[[index intValue]] forKey:@"random"];

    // Notify delegate
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(updatedFor:)])
            [self.delegate performSelector:@selector(updatedFor:) withObject:[NSString stringWithFormat:@"%@",[task valueForKey:@"id"]]];
    // Now ready to start requests for next 3 random number for next machine
    self.nextIndex++;
    if(self.nextIndex >= [self.machines count]) {
        // the random number update cycle completed
            self.nextIndex=0;
            self.syncing = FALSE;
            if(self.refreshType==Vending_Refresh_Random) {
                [self reorder];
            }
        //
        // Let delegate know all numbers updated
        //
            if(self.delegate)
                if([self.delegate respondsToSelector:@selector(refreshComplete)])
                    [self.delegate performSelector:@selector(refreshComplete)];
            NSLog(@"Sequencial data syncing completed");
    }
    else { // start getting numbers for next machine
            NSLog(@"Sequencial data sync next:%ld", (long)self.nextIndex);
            [self getNumberFor:self.nextIndex];
    }
    
}

//
// Calculate the new orders based on the averages
//
-(void)reorder
{
    [orders removeAllObjects];
    for (int i=0; i<[randomNumbers count]; i++) {
        average[i] = [NSNumber numberWithInt:(int)(([randomNumbers[i][0] floatValue]+[randomNumbers[i][1] floatValue]+[randomNumbers[i][2] floatValue])/3.0)];
        [orders addObject:[NSDictionary dictionaryWithObjectsAndKeys:average[i],@"average", [NSNumber numberWithInt:i], @"machineID", nil]];
    }
    // sort according to the average
    NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"average" ascending:NO];
    NSArray *sortDescriptors = @[ageDescriptor];
    NSArray *sortedArray = [orders sortedArrayUsingDescriptors:sortDescriptors];
    [orders removeAllObjects];
    [orders addObjectsFromArray:sortedArray];
    
}

#pragma mark - machine edit - Not implemented and not required
//To be implemented
-(void)addMachine:(NSString*)name
{
    
}

-(void)updateMachineName:(NSString*)newName for:(NSString*)machineID
{
    
}

@end
