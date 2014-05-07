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
}
@end

@implementation LECCourseViewModel

static void * localContext = &localContext;

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
            self.i = 0;
        }
        else{
            self.i = [[[lectures objectAtIndex:0] lectureNumber] unsignedIntegerValue];
        }
        
        self.tintColour = [[LECColourService sharedColourService] baseColourFor:[course colour]];
        self.colourString = [course colour];
        self.navTitle = [course courseName];
        self.subTitle = [course courseDescription];
        self.icon = [course icon];
        
        [self setupObservation];
    }
    return self;
}

-(void) dealloc
{
    [self deallocObservation];
}

-(void)deleteLectureAtIndex:(NSInteger)index
{
    LECLectureCellViewModel *lectureCell = [self.tableData objectAtIndex:index];
    Lecture *lecture = lectureCell.lecture;
    [[LECDatabaseService sharedDBService] deleteObject:lecture];
    [self.tableData removeObject:lectureCell];
}

-(void)addLecture:(NSString *)name withLectureNumber:(NSInteger)number
{
    self.i++;
    LECDatabaseService *dbService = [LECDatabaseService sharedDBService];
    newLecture = [dbService newLectureForCourse:self.currentCourse];
    newLecture.lectureName = name;
    newLecture.lectureNumber = [NSNumber numberWithUnsignedInteger:self.i];
    [dbService saveChanges];
    [self.tableData insertObject:[LECLectureCellViewModel lectureCellVMWithLecture:newLecture] atIndex:0];
}

#pragma mark - KVO
-(void) setupObservation
{
    [self.currentCourse addObserver:self forKeyPath:NSStringFromSelector(@selector(colour)) options:NSKeyValueObservingOptionNew context:localContext];
    [self.currentCourse addObserver:self forKeyPath:NSStringFromSelector(@selector(icon)) options:NSKeyValueObservingOptionNew context:localContext];
    [self.currentCourse addObserver:self forKeyPath:NSStringFromSelector(@selector(courseName)) options:NSKeyValueObservingOptionNew context:localContext];
    [self.currentCourse addObserver:self forKeyPath:NSStringFromSelector(@selector(courseDescription)) options:NSKeyValueObservingOptionNew context:localContext];
}

-(void)deallocObservation
{
    @try {
        [self.currentCourse removeObserver:self forKeyPath:NSStringFromSelector(@selector(colour))];
        [self.currentCourse removeObserver:self forKeyPath:NSStringFromSelector(@selector(icon))];
        [self.currentCourse removeObserver:self forKeyPath:NSStringFromSelector(@selector(courseName))];
        [self.currentCourse removeObserver:self forKeyPath:NSStringFromSelector(@selector(courseDescription))];
    }
    @catch (NSException * __unused exception) {}
}

// Updates view model when the managed object changes (edit screen)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != localContext) return;
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(colour))])
    {
        self.colourString = change[NSKeyValueChangeNewKey];
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(icon))])
    {
        self.icon = change[NSKeyValueChangeNewKey];
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(courseName))])
    {
        self.navTitle = change[NSKeyValueChangeNewKey];
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(courseDescription))])
    {
        self.subTitle = change[NSKeyValueChangeNewKey];
    }
    if (change[NSKeyValueChangeNewKey] == [NSNull null]) [self deallocObservation];
}

@end
