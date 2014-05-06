//
//  GEDetailTaskViewController.m
//  Overdue Task List
//
//  Created by Gary Edgcombe on 03/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GEDetailTaskViewController.h"
#import "GEEditTaskViewController.h"

@interface GEDetailTaskViewController ()<GEEditTaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *dateOfTask;
@property (weak, nonatomic) IBOutlet UILabel *taskDetails;

@end

@implementation GEDetailTaskViewController

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
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self configureView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear:");
    [self configureView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear:");
    
}

- (void)configureView
{
    self.taskName.text = self.passedInTask.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a EEE MMM d, yyyy"];
    self.dateOfTask.text = [formatter stringFromDate:[self.passedInTask date]];
    
    self.taskDetails.text = self.passedInTask.description;
}

-(void)didEditTask:(GETask *)oldTask toUpdatedTask:(GETask *)updatedTask
{
    self.passedInTask = updatedTask;
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate didPassBack:oldTask andUpdatedTask:updatedTask];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:EDIT_SEGUE sender:sender];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    if ([[segue destinationViewController] isKindOfClass:[GEEditTaskViewController class]]) {
        
        GEEditTaskViewController *editTaskVC = segue.destinationViewController;
        editTaskVC.passedInTask = self.passedInTask;
        editTaskVC.delegate = self;
    }
}

@end
