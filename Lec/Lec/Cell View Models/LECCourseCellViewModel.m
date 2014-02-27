//
//  LECCourseCellViewModel.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECCourseCellViewModel.h"

@implementation LECCourseCellViewModel

static void * localContext = &localContext;

+(LECCourseCellViewModel *) courseCellWith:(Course *)course
{
    LECCourseCellViewModel *courseCellModel = [[LECCourseCellViewModel alloc] init];
    
    [courseCellModel setCourse:course];
    [courseCellModel setTitleText:[course courseName]];
    [courseCellModel setSubText:[course courseDescription]];
    [courseCellModel setTintColour:[[LECColourService sharedColourService] baseColourFor:[course colour]]];
    [courseCellModel setIcon:[course icon]];
    
    [courseCellModel setColourString:[course colour]];
    
    [courseCellModel setupObservation];
    
    return courseCellModel;
}

#pragma mark - KVO
-(void) setupObservation
{
    [self.course addObserver:self forKeyPath:NSStringFromSelector(@selector(colour)) options:NSKeyValueObservingOptionNew context:localContext];
    [self.course addObserver:self forKeyPath:NSStringFromSelector(@selector(icon)) options:NSKeyValueObservingOptionNew context:localContext];
    [self.course addObserver:self forKeyPath:NSStringFromSelector(@selector(courseName)) options:NSKeyValueObservingOptionNew context:localContext];
    [self.course addObserver:self forKeyPath:NSStringFromSelector(@selector(courseDescription)) options:NSKeyValueObservingOptionNew context:localContext];
}

-(void)deallocObservation
{
    @try {
        [self.course removeObserver:self forKeyPath:NSStringFromSelector(@selector(colour))];
        [self.course removeObserver:self forKeyPath:NSStringFromSelector(@selector(icon))];
        [self.course removeObserver:self forKeyPath:NSStringFromSelector(@selector(courseName))];
        [self.course removeObserver:self forKeyPath:NSStringFromSelector(@selector(courseDescription))];
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
        self.titleText = change[NSKeyValueChangeNewKey];
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(courseDescription))])
    {
        self.subText = change[NSKeyValueChangeNewKey];
    }
    if (change[NSKeyValueChangeNewKey] == [NSNull null]) [self deallocObservation];
}

@end
