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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    self.editTitleTextField.text = self.passedInTask.title;
    self.editedDescriptionView.text = self.passedInTask.description;
    self.editDatePicker.date = self.passedInTask.date;
    self.completeSwitch.on = self.passedInTask.completion;
}

#pragma mark - Textfield Delegate Method

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

#pragma mark - Action Methods

- (IBAction)completedSwitchSwitched:(id)sender
{
    self.completeSwitch = (UISwitch *)sender;
    self.passedInTask.completion = self.completeSwitch.on;
}

- (IBAction)saveButtonPressed:(id)sender
{
    self.passedInTask.title = self.editTitleTextField.text;
    self.passedInTask.description = self.editedDescriptionView.text;
    self.passedInTask.date = self.editDatePicker.date;
    self.passedInTask.completion = self.completeSwitch.on;
    [self.delegate didEditTask];
    
}

@end
