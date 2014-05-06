//
//  GEAddTaskViewController.m
//  Overdue Task List
//
//  Created by Gary Edgcombe on 03/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GEAddTaskViewController.h"

@interface GEAddTaskViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

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

#pragma mark - Helper Methods

- (GETask *)createANewTask
{
    GETask *newTask = [[GETask alloc]initWithTitle: self.titleTextField.text
                                       description:self.descriptionTextView.text
                                              date:self.datePicker.date
                                        completion:NO];
    return newTask;
}

#pragma mark - TextFiels Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
