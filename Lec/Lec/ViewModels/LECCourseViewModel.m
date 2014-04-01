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
    unsigned long i; //the Lecture Number
}
@end

@implementation LECCourseViewModel

-(instancetype)initWithCourse:(Course *) course
{
    self = [super init];
    if (self){
        self.currentCourse = course;
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lectureNumber" ascending:NO];
        NSArray *lectures = [[course.lectures allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        for (Lecture *lec in lectures)
        {
            [self.tableData addObject:[LECLectureCellViewModel lectureCellVMWithLecture:lec]];
        }
        if ((unsigned int)[lectures count] == 0) {
            i = 0;
        }
        else{
            i = [[[lectures objectAtIndex:0] lectureNumber] unsignedIntegerValue];
        }
        
        self.tintColour = [[LECColourService sharedColourService] baseColourFor:[course colour]];
        self.colourString = [course colour];
        self.navTitle = [course courseName];
        self.subTitle = [course courseDescription];
        self.icon = [course icon];
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
    i++;
    LECDatabaseService *dbService = [LECDatabaseService sharedDBService];
    newLecture = [dbService newLectureForCourse:self.currentCourse];
    newLecture.lectureName = name;
    newLecture.lectureNumber = [NSNumber numberWithUnsignedInteger:i];
    [dbService saveChanges];
    [self.tableData insertObject:[LECLectureCellViewModel lectureCellVMWithLecture:newLecture] atIndex:0];
}

@end
