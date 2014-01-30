//
//  LECCourseViewModel.m
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECCourseViewModel.h"
#import "LECLectureCellViewModel.h"

@interface LECCourseViewModel (){
    Lecture *newLecture;
    LECDatabaseService *dbService;
    int i; //the Lecture Number
}
@end

@implementation LECCourseViewModel

-(instancetype)initWithCourse:(Course *) course
{
    self = [super init];
    if (self){
        self.currentCourse = course;
        dbService = [LECDatabaseService sharedDBService];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lectureNumber" ascending:NO];
        NSArray *lectures = [[course.lectures allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        for (Lecture *lec in lectures)
        {
            [self.tableData addObject:[LECLectureCellViewModel lectureCellVMWithLecture:lec]];
        }
        if ((unsigned int)[lectures count] == 0) {
            i = 1;
        }
        else{
            i = (unsigned int)[lectures count];
        }
        self.tintColour = [[LECColourService sharedColourService] baseColourFor:[course colour]];
        self.navTitle = [course courseName];
    }
    return self;
}

-(void)deleteLectureAtIndex:(NSInteger)index
{
    LECLectureCellViewModel *lectureCell = [self.tableData objectAtIndex:index];
    Lecture *lecture = lectureCell.lecture;
    [[LECDatabaseService sharedDBService] deleteObject:lecture];
    [self.tableData removeObject:lectureCell];
}

-(void)addLecture:(NSString *)name
{
    newLecture = [dbService newLectureForCourse:self.currentCourse];
    newLecture.lectureName = name;
    newLecture.lectureNumber = [NSNumber numberWithInt:i];
    [[LECDatabaseService sharedDBService] saveChanges];
    [self.tableData insertObject:[LECLectureCellViewModel lectureCellVMWithLecture:newLecture] atIndex:0];
    i++;
}

@end
