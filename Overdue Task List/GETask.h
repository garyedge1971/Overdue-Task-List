//
//  GETask.h
//  Overdue Task List
//
//  Created by Gary Edgcombe on 04/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GETask : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL completion;


- (id)initWithData:(NSDictionary *)data;


- (id)initWithTitle:(NSString *)title
        description:(NSString *)description
               date:(NSDate *)date
         completion:(BOOL) completion;
@end
