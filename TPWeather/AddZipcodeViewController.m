//
//  AddZipcodeViewController.m
//  TPWeather
//
//  Created by David on 5/23/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import "AddZipcodeViewController.h"

@interface AddZipcodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation AddZipcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addZipcode:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
