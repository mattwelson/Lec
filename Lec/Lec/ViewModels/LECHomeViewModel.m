//
//  LECHomeViewModel.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECHomeViewModel.h"
#import "LECCourseCellViewModel.h"

@implementation LECHomeViewModel

-(instancetype)init
{
    self = [super init];
    if (self){
        NSArray *modelData = [[LECDatabaseService sharedDBService] getCourses];
        for (Course *course in modelData)
        {
            [self.tableData addObject:[LECCourseCellViewModel courseCellWith:course]];
            NSLog(@"Colour: %@", course.colour);
        }
    }
    return self;
}

@end
