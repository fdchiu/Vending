//
//  DataViewController.m
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import "DataViewController.h"
#import "DataController.h"


@interface DataViewController () {
}
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"DataViewController: showing machine: %@ (average - %@)", [self.dataObject valueForKey:@"machine"],[self.dataObject valueForKey:@"average"]);

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refresh];
    
}
//
// handle display of the vending machines data including name, image, average & random numbers
//
-(void)refresh
{
    self.dataLabel.text = [(NSDictionary*)self.dataObject objectForKey:@"machine"];
    self.averageLabel.text = [[(NSDictionary*)self.dataObject objectForKey:@"average"] description];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, h:mm a"];
    
    NSArray *subview=[self.machineImageView subviews];
    if( subview && [subview count]>0)
        [[[self.machineImageView subviews] objectAtIndex:0] removeFromSuperview];
    
    UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[DataController getImageForMachine:[self.dataObject objectForKey:@"id"] ]]];
    [imgv setFrame:CGRectMake(0,0, self.machineImageView.frame.size.width, self.machineImageView.frame.size.height)];
    [self.machineImageView addSubview:imgv];
    
    self.dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *random=[self.dataObject objectForKey:@"random"];
    for (int i=0; i<[random count]; i++) {
        [self.randomNumberSeq setTitle:[NSString stringWithFormat:@"%@",random[i]] forSegmentAtIndex:i];
    }
}
@end
