//
//  GEViewController.m
//  Overdue Task List
//
//  Created by Gary Edgcombe on 03/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GEViewController.h"
#import "GEAddTaskViewController.h"
#import "GEDetailTaskViewController.h"
#import "GESettingsTableViewController.h"
#import "GETask.h"
#import "GESettings.h"

@interface GEViewController ()<GEAddTaskViewControllerDelegate,GEDetailTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

// Arrays
@property (strong, nonatomic) NSMutableArray *allTaskObjects;
@property (strong, nonatomic) NSMutableArray *greenTasks;
@property (strong, nonatomic) NSMutableArray *amberTasks;
@property (strong, nonatomic) NSMutableArray *redTasks;
@property (strong, nonatomic) NSArray *greenOrderedTasks;
@property (strong, nonatomic) NSArray *amberOrderedTasks;
@property (strong, nonatomic) NSArray *redOrderedTasks;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) GESettings *settings;

@end

@implementation GEViewController
{
    BOOL _isEditing;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self retrieveStoredData];
    [self arrangeAllTasksIntoColorCodedArrays];
    [self arrangeTasksIntoAlphabeticalOrder];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    [self saveTasks];
    [self retrieveStoredData];
    [self arrangeAllTasksIntoColorCodedArrays];
    [self arrangeTasksIntoAlphabeticalOrder];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy instantiations

-(GESettings *)settings
{
    if (!_settings) {
        _settings = [[GESettings alloc]init];
        _settings.isCapitalised = YES;
    }
    
    return _settings;
}

-(NSMutableArray *)allTaskObjects
{
    if (!_allTaskObjects) {
        _allTaskObjects = [@[]mutableCopy];
    }
    
    return _allTaskObjects;
}

-(NSMutableArray *)greenTasks
{
    if (!_greenTasks) {
        _greenTasks = [@[]mutableCopy];
    }
    return _greenTasks;
}

-(NSMutableArray *)amberTasks
{
    if (!_amberTasks) {
        _amberTasks = [@[]mutableCopy];
    }
    return _amberTasks;
}

-(NSMutableArray *)redTasks
{
    if (!_redTasks) {
        _redTasks = [@[]mutableCopy];
    }
    return _redTasks;
}

-(NSArray *)greenOrderedTasks
{
    if (!_greenOrderedTasks) {
        _greenOrderedTasks = [@[]mutableCopy];
    }
    return _greenOrderedTasks;
}

-(NSArray *)amberOrderedTasks
{
    if (!_amberOrderedTasks) {
        _amberOrderedTasks = [@[]mutableCopy];
    }
    return _amberOrderedTasks;
}

-(NSArray *)redOrderedTasks
{
    if (!_redOrderedTasks) {
        _redOrderedTasks = [@[]mutableCopy];
    }
    return _redOrderedTasks;
}

#pragma mark - GEDetailView Delegate
-(void)didEditTask
{
    [self saveTasks];
    
    [self.tableView reloadData];
}

#pragma mark - Action Methods

- (IBAction)settingsButtonTapped:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"SettingsSegue" sender:sender];
    
}

- (IBAction)addTaskButtonPressed:(id)sender {
    [self performSegueWithIdentifier:ADD_TASK_SEGUE sender:sender];
    
}

#pragma mark - Delegate Methods
-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(GETask *)task
{
    [self.allTaskObjects addObject:task];
    [self saveTasks];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Methods

- (void)retrieveStoredData
{
    [self.allTaskObjects removeAllObjects];
    
    // Get Stored Data
    NSArray *allStoredData = [[NSUserDefaults standardUserDefaults]arrayForKey:TASK_ENTRIES];
    
    for (NSDictionary *storedTask in allStoredData) {
        // Convert to GETask Object
        GETask *aTask = [self taskObjectFromDictObject:storedTask];
        // Add to taskObjects array
        [self.allTaskObjects addObject:aTask];
    }
}

-(void)arrangeAllTasksIntoColorCodedArrays
{
    // Remove all existing objects
    [self.greenTasks removeAllObjects];
    [self.amberTasks removeAllObjects];
    [self.redTasks removeAllObjects];
    
    // Iterate throught the main array of objects and add them in
    for (GETask *task in self.allTaskObjects) {
        
        if (task.completion) {
            [self.greenTasks addObject:task];
        }
        
        else if ([self isDateGreaterThanCurrentDate:task.date]) {
            [self.amberTasks addObject:task];
        }
        
        else{
            // Put task into the overdue array
            [self.redTasks addObject:task];
        }
    }
}

- (void)arrangeTasksIntoAlphabeticalOrder
{
    // Iterate through each coloured array comparing order
    // Add to ordered array
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    self.greenOrderedTasks = [self.greenTasks sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    self.amberOrderedTasks = [self.amberTasks sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    self.redOrderedTasks = [self.redTasks sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    
    NSLog(@"sorted green array = %@", [self.greenOrderedTasks description]);
}

-(NSDictionary *)taskObjectAsAPropertyList:(GETask *)taskObject
{
    NSDictionary *taskAsDict = [[NSDictionary alloc]init];
    
    taskAsDict = @{TITLE : taskObject.title,
                   DESCRIPTION : taskObject.description,
                   DATE : taskObject.date,
                   COMPLETION : @(taskObject.completion)
                   };
    
    return taskAsDict;
    
}

-(GETask *)taskObjectFromDictObject:(NSDictionary *)dictObject
{
    GETask *taskObject = [[GETask alloc] initWithData:dictObject];
    
    return taskObject;
}

- (BOOL)isDateGreaterThanCurrentDate:(NSDate *)date
{
    NSTimeInterval time = [date timeIntervalSinceNow];
    
    if (time >0) {
        return YES;
    }
    else return NO;
    
}

-(void)updateCompletionOfTask:(GETask *)task
{
    
    task.completion = !task.completion;
    
    [self saveTasks];
    [self arrangeAllTasksIntoColorCodedArrays];
    [self arrangeTasksIntoAlphabeticalOrder];
    [self.tableView reloadData];
    
}

- (void)saveTasks
{
    //create empty Mutable Array
    
    NSMutableArray *allTasksAsDictionarys = [@[]mutableCopy];
    //iterate through out objects array converting each object to a dict object and add that to allTasksAsDictionary array
    
    for (GETask *eachTask in self.allTaskObjects) {
        NSDictionary *dictTask = [self taskObjectAsAPropertyList:eachTask];
        [allTasksAsDictionarys addObject:dictTask];
    }
    
    // Save Stored array to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:allTasksAsDictionarys forKey:TASK_ENTRIES];
    // Always sync after saving
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

#pragma mark - TableView Datasource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.greenTasks.count;
    }
    else if (section == 1){
        return self.amberTasks.count;
    }
    else return self.redTasks.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"completed tasks";
    else if (section == 1) return @"incomplete tasks";
    
    return @"overdue tasks";
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    GETask *selectedTask;
    
    if (!self.settings.isSortedIntoAlphabeticalOrder) {
        
        if (indexPath.section == 0) {
            selectedTask = self.greenTasks[indexPath.row];
            
        }
        else if (indexPath.section == 1) {
            selectedTask = self.amberTasks[indexPath.row];
        }
        else{
            selectedTask = self.redTasks[indexPath.row];
        }
    }
    else
    {
        
        if (indexPath.section == 0) {
            selectedTask = self.greenOrderedTasks[indexPath.row];
            
        }
        else if (indexPath.section == 1) {
            selectedTask = self.amberOrderedTasks[indexPath.row];
        }
        else{
            selectedTask = self.redOrderedTasks[indexPath.row];
        }
        
    }
    // Configure cell and detail label
    // Check to see if Capitalise is set in settings
    if (self.settings.isCapitalised) {
        NSString *newCapitalizedString = [selectedTask.title capitalizedString];
        cell.textLabel.text = newCapitalizedString;
    }
    else cell.textLabel.text = selectedTask.title;
    //format date for detail label
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h:mm a EEE MMM d, yyyy"];
    NSString *date = [formatter stringFromDate:selectedTask.date];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = date;
    
    // Configure cell backgrounds
    if (indexPath.section == 0) {
        cell.backgroundColor = RGB(50*(indexPath.row), 255, 50*(indexPath.row));
    }
    else if (indexPath.section == 1) {
        cell.backgroundColor = RGB(255, 234+(indexPath.row*2), 50*(indexPath.row));
    }
    else cell.backgroundColor = RGB(255, 50*(indexPath.row), 50*(indexPath.row));
    
    return cell;
}


#pragma mark - TableView Delegate Methods

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessory button tapped");
    [self performSegueWithIdentifier:DETAIL_PUSH_SEGUE sender:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get Task Object at index
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    GETask *selectedTask;
    switch (section) {
        case 0:
            selectedTask = self.greenTasks[row];
            break;
        case 1:
            selectedTask = self.amberTasks[row];
            break;
        case 2:
            selectedTask = self.redTasks[row];
            break;
            
        default:
            break;
    }
    
    [self updateCompletionOfTask:selectedTask];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Remove task from allTaskObjects
        GETask *taskToDelete;
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        
        switch (section) {
            case 0:
                taskToDelete = self.greenTasks[row];
                break;
            case 1:
                taskToDelete = self.amberTasks[row];
                break;
            case 2:
                taskToDelete = self.redTasks[row];
                break;
                
            default:
                break;
        }
        
        [self.allTaskObjects removeObject:taskToDelete];
        
        [self saveTasks];
        [self arrangeAllTasksIntoColorCodedArrays];
        [self arrangeTasksIntoAlphabeticalOrder];
        
                
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"row deleted");
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    GETask *taskToMove;
//    NSUInteger section = fromIndexPath.section;
//    NSUInteger row = toIndexPath.row;
//
//    switch (section) {
//        case 0:
//            taskToMove = self.greenObjects[row];
//            break;
//        case 1:
//            taskToMove = self.amberObjects[row];
//            break;
//        case 2:
//            taskToMove = self.redObjects[row];
//            break;
//
//        default:
//            break;
//    }
//
//    [self.allTaskObjects removeObject:taskToMove];
//    [self.allTaskObjects insertObject:taskOnTheMove atIndex:toIndexPath.row];
//
//    [self saveTasks];
//    [self arrangeAllTasksIntoColorCodedArrays];
//
//    NSLog(@"task moved");
//}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue destinationViewController] isKindOfClass:[GEAddTaskViewController class]]) {
        GEAddTaskViewController *addTaskVC = segue.destinationViewController;
        
        addTaskVC.delegate = self;
    }
    
    else if ([[segue destinationViewController] isKindOfClass:[GEDetailTaskViewController class]])
    {
        GEDetailTaskViewController *detailTaskVC = segue.destinationViewController;
        
        GETask *taskToPassIn;
        
        NSIndexPath *indexPath = sender;
        if (indexPath.section == 0) {
            taskToPassIn = self.greenTasks[indexPath.row];
        }
        else if (indexPath.section == 1){
            taskToPassIn = self.amberTasks[indexPath.row];
        }
        else if (indexPath.section == 2){
            taskToPassIn = self.redTasks[indexPath.row];
        }
        
        detailTaskVC.passedInTask = taskToPassIn;
        detailTaskVC.delegate = self;
    }
    
    else if ([segue.identifier isEqualToString:@"SettingsSegue"]){
        GESettingsTableViewController *settingsVC = segue.destinationViewController;
        settingsVC.passedInSettings = self.settings;
    }
}

@end
