//
//  GESettingsTableViewController.h
//  Overdue Task List
//
//  Created by Gary Edgcombe on 11/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GESettings.h"

@interface GESettingsTableViewController : UITableViewController

// Outlets
@property (weak, nonatomic) IBOutlet UISwitch *alphabetSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *capitaliseSwitch;


// Model
@property (strong, nonatomic) GESettings *passedInSettings;

@end
