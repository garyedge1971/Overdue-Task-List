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
#import "GETask.h"

@interface GEViewController ()<GEAddTaskViewControllerDelegate,GEDetailTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

// Arrays
@property (strong, nonatomic) NSMutableArray *allTaskObjects;
@property (strong, nonatomic) NSMutableArray *greenObjects;
@property (strong, nonatomic) NSMutableArray *amberObjects;
@property (strong, nonatomic) NSMutableArray *redObjects;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    // Get Stored Data
    NSArray *allStoredData = [[NSUserDefaults standardUserDefaults]arrayForKey:TASK_ENTRIES];
    
    for (NSDictionary *storedTask in allStoredData) {
        // Convert to GETask Object
        GETask *aTask = [self taskObjectFromDictObject:storedTask];
        // Add to taskObjects array
        [self.allTaskObjects addObject:aTask];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy instantiations
-(NSMutableArray *)allTaskObjects
{
    if (!_allTaskObjects) {
        _allTaskObjects = [@[]mutableCopy];
    }
    
    return _allTaskObjects;
}

-(NSMutableArray *)greenObjects
{
    if (_greenObjects) {
        _greenObjects = [@[]mutableCopy];
    }
    return _greenObjects;
}

-(NSMutableArray *)amberObjects
{
    if (_amberObjects) {
        _amberObjects = [@[]mutableCopy];
    }
    return _amberObjects;
}

-(NSMutableArray *)redObjects
{
    if (_redObjects) {
        _redObjects = [@[]mutableCopy];
    }
    return _redObjects;
}


#pragma mark - GEDetailView Delegate
-(void)didPassBack:(GETask *)oldTask andUpdatedTask:(GETask *)updatedTask
{
    // Remove old task from Array
    NSUInteger indexOfTask = [self.allTaskObjects indexOfObject:oldTask];
    NSLog(@"index of object to remove is %lu", (unsigned long)indexOfTask);
    
    [self.allTaskObjects removeObjectAtIndex:indexOfTask];
    
    // Add New Task to Array
    [self.allTaskObjects insertObject:updatedTask atIndex:indexOfTask];
    
    // Save tasks to NSUserDefaults
    
    [self saveTasks];
}

#pragma mark - Action Methods
- (IBAction)reorderButtonPressed:(id)sender
{
    _isEditing = !_isEditing;
    
    self.tableView.editing = _isEditing;
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
    
    NSMutableArray *storedTasksArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_ENTRIES]mutableCopy];
    
    if (!storedTasksArray) {
        storedTasksArray = [[NSMutableArray alloc]init];
    }
    
    [storedTasksArray addObject:[self taskObjectAsAPropertyList:task]];
    
    // Persist Data
    
    [[NSUserDefaults standardUserDefaults] setObject:storedTasksArray forKey:TASK_ENTRIES];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Methods
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
    NSLog(@"Time Interval = %f", time);
    if (time >0) {
        return YES;
    }
    else return NO;
    
}

-(void)updateCompletionOfTask:(GETask *)task forIndexPath:(NSIndexPath *)indexPath
{
    
    // Get Stored Array
    NSMutableArray *storedArray = [[[NSUserDefaults standardUserDefaults]arrayForKey:TASK_ENTRIES]mutableCopy];
    // Remove Entry From Array
    [storedArray removeObjectAtIndex:indexPath.row];
    
    // Create new updatedtask from this one
    GETask *updatedTask = [[GETask alloc]initWithTitle:task.title description:task.description date:task.date completion:!(task.completion)];
    
    // Now we can Remove old task from array
    [self.allTaskObjects removeObjectAtIndex:indexPath.row];
    
    // Add the new cloned object in at the same index
    [self.allTaskObjects insertObject:updatedTask atIndex:indexPath.row];
    
    // Convert this cloned object to NSDictionary object
    NSDictionary *updatedTaskAsDict =  [self taskObjectAsAPropertyList:updatedTask];
    [storedArray insertObject:updatedTaskAsDict atIndex:indexPath.row];
    
    // Save Stored array to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:storedArray forKey:TASK_ENTRIES];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
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
    
    return [self.allTaskObjects count];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) return @"completed tasks";
//    else if (section == 1) return @"incomplete tasks";
//    
//    return @"overdue tasks";
//    
//}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Get Task object for indexPath
    GETask *selectedTask = self.allTaskObjects[indexPath.row];
    
    //Get task completion status
    BOOL isComplete = selectedTask.completion;
    
    // Configure cell and detail label
    cell.textLabel.text = selectedTask.title;
    //format date for detail label
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h:mm a EEE MMM d, yyyy"];
    NSString *date = [formatter stringFromDate:selectedTask.date];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = date;
    
    // Configure cell backgrounds
    if (isComplete) {
        cell.backgroundColor = [UIColor greenColor];
    }
    else if ([self isDateGreaterThanCurrentDate:selectedTask.date]) {
        cell.backgroundColor = [UIColor yellowColor];
    }
    else cell.backgroundColor = [UIColor redColor];
    
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
    GETask *selectedTask = self.allTaskObjects[indexPath.row];
    
    [self updateCompletionOfTask:selectedTask forIndexPath:indexPath];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.allTaskObjects removeObjectAtIndex:indexPath.row];
        
        //delete object from NSUserDefaults
        NSMutableArray *storedArray = [[[NSUserDefaults standardUserDefaults]arrayForKey:TASK_ENTRIES]mutableCopy];
        // Remove Entry From Array
        [storedArray removeObjectAtIndex:indexPath.row];
        
        // Save Stored array to NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:storedArray forKey:TASK_ENTRIES];
        //sync after saving
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    GETask *taskOnTheMove = self.allTaskObjects[fromIndexPath.row];
    [self.allTaskObjects removeObject:taskOnTheMove];
    [self.allTaskObjects insertObject:taskOnTheMove atIndex:toIndexPath.row];
    
    [self saveTasks];
    
    NSLog(@"Array = %@", [self.allTaskObjects description]);
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
        
        NSIndexPath *indexPath = sender;
        GETask *taskToPassIn = self.allTaskObjects[indexPath.row];
        
        detailTaskVC.passedInTask = taskToPassIn;
        detailTaskVC.delegate = self;
    }
}

@end
