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
@property (strong, nonatomic) UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *completeSwitch;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear:");
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

- (void)configureView
{
    self.taskName.text = self.passedInTask.title;
    self.completeSwitch.on = self.passedInTask.completion;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a EEE MMM d, yyyy"];
    self.dateOfTask.text = [formatter stringFromDate:[self.passedInTask date]];
    
    if (self.taskDescriptionLabel) {
        // Remove subView From superView
        [self.taskDescriptionLabel removeFromSuperview];
    }
    
    // Add Description Label in code to dynamically change size
    CGRect labelFrame = CGRectMake(20, 210, 280, 260);
    
    self.taskDescriptionLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    self.taskDescriptionLabel.numberOfLines = 0;
    //self.taskDescriptionLabel.backgroundColor = [UIColor lightGrayColor];
    self.taskDescriptionLabel.text = self.passedInTask.description;
    // Resize to fit addedText
    [self.taskDescriptionLabel sizeToFit];
    // Add to View
    [self.view addSubview:self.taskDescriptionLabel];
}

#pragma mark - Delegate Methods

-(void)didEditTask
{
    [self.navigationController popViewControllerAnimated:YES];
   
    [self.delegate didEditTask];
    
}

#pragma mark - Action Methods
- (IBAction)editButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:EDIT_SEGUE sender:sender];
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
