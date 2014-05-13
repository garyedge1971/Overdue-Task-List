//
//  GEEditTaskViewController.h
//  Overdue Task List
//
//  Created by Gary Edgcombe on 03/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GETask.h"

@protocol  GEEditTaskViewControllerDelegate<NSObject>

@required
- (void)didEditTask;

@end

@interface GEEditTaskViewController : UIViewController

@property (weak, nonatomic) id<GEEditTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) GETask *passedInTask;

@end
