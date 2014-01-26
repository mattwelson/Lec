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
    
    
    NSArray *lectures = [course.lectures allObjects];
    for (Lecture *lec in lectures)
    {
        [viewModel.tableData insertObject:[LECLectureCellViewModel lectureCellVMWithLecture:lec] atIndex:0];
    }
    
    return viewModel;
}

@end
