//
//  AddMachineViewController.m
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import "AddMachineViewController.h"
#import "DataController.h"

@interface AddMachineViewController ()
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation AddMachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    //    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer1];
    [recognizer1 setCancelsTouchesInView:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tapped:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
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
    
    NSString *tmpString=[self.zipcodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.dataController addMachine:tmpString];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Machine  added:%@",tmpString);

}


#pragma mark - UITextFieldDelegate method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.statusLabel setText:@""];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *userInputString=[[textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [textField setText:userInputString];
    NSLog(@"Validate machine name entered by user: %@", userInputString);
}

@end
