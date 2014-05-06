//
//  GEDetailTaskViewController.h
//  Overdue Task List
//
//  Created by Gary Edgcombe on 03/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GETask.h"

@protocol GEDetailTaskViewControllerDelegate <NSObject>

@required
- (void) didPassBack:(GETask *)oldTask andUpdatedTask:(GETask *)updatedTask;

@end
@interface GEDetailTaskViewController : UIViewController

@property (weak, nonatomic) id<GEDetailTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) GETask *passedInTask;

@end
