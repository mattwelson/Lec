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
        }
        self.navTitle = @"My Courses"; // This is where this should be set.
    }
    return self;
}

-(void)updateCourseIndexes{
    
    int indexCount = self.tableData.count-1;
    for(int i = 0; i < self.tableData.count; i++) {
        LECCourseCellViewModel *courseCell = [self.tableData objectAtIndex:indexCount-i];
        Course *course = courseCell.course;
        course.courseIndex = [NSNumber numberWithInt:i];
        [[LECDatabaseService sharedDBService] saveChanges]; // saves changes made to course scratch pad
    }
    
}

-(void)deleteCourseAtIndex:(NSInteger)index
{
    LECCourseCellViewModel *courseCell = [self.tableData objectAtIndex:index];
    Course *course = courseCell.course;
    [[LECDatabaseService sharedDBService] deleteObject:course];
    [self.tableData removeObject:courseCell];
}

@end
