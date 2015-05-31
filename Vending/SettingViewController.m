//
//  SettingViewController.m
//  Vending
//
//  Created by David on 5/24/15.
//  Copyright (c) 2015 David Chiu. All rights reserved.
//

#import "SettingViewController.h"
#import "AddMachineViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *queryTypeSC;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;

@end


@implementation SettingViewController
@synthesize dataController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //gestures
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    [self.queryTypeSC setSelectedSegmentIndex:[self.dataController refreshType]];
    
    /*recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
     */

}
-(void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
    NSLog(@"Showing settings screen");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSwipe:(UISwipeGestureRecognizer*)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)changeQueryMethod:(id)sender {
    [self.dataController setRefreshType:[(UISegmentedControl*)sender selectedSegmentIndex]];
    NSLog(@"Machine query method changed");
}

- (IBAction)done:(id)sender {
    [self.dataController saveSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Exit Setting screen");

}
- (IBAction)addMachine:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *vC=[storyboard instantiateViewControllerWithIdentifier:@"AddMachineViewController"];
    [(AddMachineViewController*)vC setDataController:self.dataController];
    [self presentViewController:vC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController count];
}

//prepare the cell for the tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MachineCell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MachineCell"];
    
    NSDictionary *machine=[self.dataController objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[DataController getImageForMachine:[machine objectForKey:@"id"]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",[machine objectForKey:@"machine"],[machine objectForKey:@"average"]];
    

    NSLog(@"Seetings: create new table cell: %@", cell.textLabel.text);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//
// editing, particular deletion of machine. It is not required so delete does not actually working
//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //NSLog(@"Machine  to be deleted:%@",[[self.dataController objectAtIndex:indexPath.row] valueForKey:@"machine"]);
        //[self.dataController removeObjectAtIndex:indexPath.row];
        [tableView reloadData];

    }
}

//
// enable reorder of the machines when "fixed" is selected in settings
//
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.dataController allowReorder])
        return YES;
    return NO;
}

//
// Does the actual work of moving table cells
//
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.dataController moveObjectFrom:sourceIndexPath.row to:destinationIndexPath.row];
    }

//
// Put machine tableview in edit mode
//
- (IBAction)edit:(id)sender {

    if(self.tableView.editing)
    {
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.editBtn setTitle:@"Edit"];
       //[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
       // [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.editBtn setTitle:@"Finish"];
    }
}
@end
