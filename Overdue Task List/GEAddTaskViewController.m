//
//  GEAddTaskViewController.m
//  Overdue Task List
//
//  Created by Gary Edgcombe on 03/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GEAddTaskViewController.h"

@interface GEAddTaskViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *editedTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *editedDatePicker;

@end

@implementation GEAddTaskViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)cancelButtonPressed:(id)sender
{
    [self.delegate didCancel];
}

- (IBAction)addTaskButtonPressed:(id)sender
{
    // Create task object
    GETask *newTask = [self createANewTask];
    
    // Pass back to MainViewController
    [self.delegate didAddTask:newTask];
    
}

- (IBAction)doneInsertingText:(id)sender {
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark - Helper Methods

- (GETask *)createANewTask
{
    GETask *newTask = [[GETask alloc]initWithTitle: self.editedTextField.text
                                       description:self.descriptionTextView.text
                                              date:self.editedDatePicker.date
                                        completion:NO];
    return newTask;
}

#pragma mark - TextFields Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
