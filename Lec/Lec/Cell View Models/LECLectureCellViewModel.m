//
//  LECLectureCellViewModel.m
//  Lec
//
//  Created by Matt Welson on 26/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECLectureCellViewModel.h"
#import "Course.h"

@implementation LECLectureCellViewModel

static void * localContext = &localContext;

+(instancetype)lectureCellVMWithLecture:(Lecture *)lecture
{
    LECLectureCellViewModel *cellViewModel = [[LECLectureCellViewModel alloc] init];
    
    cellViewModel.lecture = lecture;
    cellViewModel.tintColour = [[LECColourService sharedColourService] baseColourFor:[lecture.course colour]];
    cellViewModel.titleText = [NSString stringWithFormat:@"Lecture %@",lecture.lectureNumber];
    cellViewModel.subText = [lecture lectureName];
    cellViewModel.colourString = [[lecture course] colour];
    [cellViewModel setupObservation];
    return cellViewModel;
}

-(void)dealloc
{
    [self deallocObservation];
}

#pragma mark - KVO
-(void) setupObservation
{
    [self.lecture addObserver:self forKeyPath:NSStringFromSelector(@selector(lectureName)) options:NSKeyValueObservingOptionNew context:localContext];
    [self.lecture addObserver:self forKeyPath:NSStringFromSelector(@selector(lectureNumber)) options:NSKeyValueObservingOptionNew context:localContext];
}

-(void)deallocObservation
{
    @try {
        [self.lecture removeObserver:self forKeyPath:NSStringFromSelector(@selector(lectureName))];
        [self.lecture removeObserver:self forKeyPath:NSStringFromSelector(@selector(lectureNumber))];
    }
    @catch (NSException * __unused exception) {}
}

// Updates view model when the managed object changes (edit screen)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != localContext) return;
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(lectureName))])
    {
        self.subText = change[NSKeyValueChangeNewKey];
    }
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(lectureNumber))])
    {
        self.titleText = [NSString stringWithFormat:@"Lecture %@", change[NSKeyValueChangeNewKey]];
    }
    if (change[NSKeyValueChangeNewKey] == [NSNull null]){
        [self deallocObservation];
        return;
    }
}


@end
