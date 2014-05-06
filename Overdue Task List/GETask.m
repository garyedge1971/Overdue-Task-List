//
//  GETask.m
//  Overdue Task List
//
//  Created by Gary Edgcombe on 04/05/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GETask.h"


@implementation GETask

-(id)init{
    self = [self initWithData:nil];
    
    return self;
}


-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _title = data[TITLE];
        _description = data[DESCRIPTION];
        _date = data[DATE];
        _completion =  [data[COMPLETION]boolValue];
    }
    
    return self;
}

-(id)initWithTitle:(NSString *)title description:(NSString *)description date:(NSDate *)date completion:(BOOL)completion
{
    self = [super init];
    if (self) {
        _title = title;
        _description = description;
        _date = date;
        _completion = completion;
    }
    return self;
}

// Task object Back to NSDictionary Conversion

- (NSDictionary *)taskDictionaryObjectFrom:(GETask *)taskName
{
    NSDictionary *taskAsDict = [[NSDictionary alloc]init];
    
    taskAsDict = @{TITLE : taskName.title,
                   DESCRIPTION : taskName.description,
                   DATE : taskName.date,
                   COMPLETION : @(taskName.completion)
                   };
    
    return taskAsDict;
}

@end
