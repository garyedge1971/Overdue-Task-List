//
//  GEEditTaskViewController.m
//  Overdue Task List
//
//  Created by Gary Edgcombe on 03/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GEEditTaskViewController.h"

@interface GEEditTaskViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *editTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *editedDescriptionView;
@property (weak, nonatomic) IBOutlet UIDatePicker *editDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *completeSwitch;

@end

@implementation GEEditTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)configureView
{
    self.editTitleTextField.text = self.passedInTask.title;
    self.editedDescriptionView.text = self.passedInTask.description;
    self.editDatePicker.date = self.passedInTask.date;
    self.completeSwitch.on = self.passedInTask.completion;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action Methods

- (IBAction)doneInsertingText:(id)sender
{
    [self.editedDescriptionView resignFirstResponder];
}

- (IBAction)completedSwitchSwitched:(id)sender
{
    self.completeSwitch = (UISwitch *)sender;
    self.passedInTask.completion = self.completeSwitch.on;
    if (self.completeSwitch.on) {
        NSLog(@"Switch is on");
    }
    else NSLog(@"Switch is off");
    
}

- (IBAction)saveButtonPressed:(id)sender
{
    // Create a new Task object
    GETask *updatedTask = [[GETask alloc]initWithTitle:self.editTitleTextField.text
                                          description:self.editedDescriptionView.text
                                                 date:self.editDatePicker.date
                                           completion:self.completeSwitch.on];
    
    NSLog(@"updated task completion status = %d", self.completeSwitch.on);
    
    [self.delegate didEditTask:self.passedInTask toUpdatedTask:updatedTask];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
