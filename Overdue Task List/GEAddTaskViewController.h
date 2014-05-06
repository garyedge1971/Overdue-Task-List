//
//  GEAddTaskViewController.h
//  Overdue Task List
//
//  Created by Gary Edgcombe on 03/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GETask.h"

@protocol GEAddTaskViewControllerDelegate <NSObject>

@required
- (void)didCancel;
- (void)didAddTask:(GETask *)task;

@end
@interface GEAddTaskViewController : UIViewController

@property (weak, nonatomic) id<GEAddTaskViewControllerDelegate> delegate;

@end
