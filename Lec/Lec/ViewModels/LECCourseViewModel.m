//
//  LECCourseViewModel.m
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECCourseViewModel.h"
#import "LECLectureCellViewModel.h"

@implementation LECCourseViewModel

+(LECCourseViewModel *)courseViewModelWithCourse:(Course *)course
{
    LECCourseViewModel *viewModel = [[LECCourseViewModel alloc] init];
    
    viewModel.course = course;
    viewModel.tintColour = [[LECColourService sharedColourService] baseColourFor:[course colour]];
    viewModel.navTitle = [course courseName];
    
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lectureNumber" ascending:NO];
    NSArray *lectures = [[course.lectures allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for (Lecture *lec in lectures)
    {
        [viewModel.tableData addObject:[LECLectureCellViewModel lectureCellVMWithLecture:lec]];
    }
    
    return viewModel;
}
-(void)deleteLectureAtIndex:(NSInteger)index
{
    LECLectureCellViewModel *lectureCell = [self.tableData objectAtIndex:index];
    Lecture *lecture = lectureCell.lecture;
    [[LECDatabaseService sharedDBService] deleteObject:lecture];
    [self.tableData removeObject:lectureCell];
}

@end
