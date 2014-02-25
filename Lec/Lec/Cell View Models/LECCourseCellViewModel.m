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
// observe course name
// observe course description
    [self.course addObserver:self forKeyPath:NSStringFromSelector(@selector(colour)) options:NSKeyValueObservingOptionNew context:localContext];
// observe icon
}

// Updates view model when the managed object changes (edit screen)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != localContext) return;
    // if course name
       // update title text
    // if course description
       // update sub text
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(colour))])
    {
        self.colourString = change[NSKeyValueChangeNewKey];
    }
    // if icon
         // update icon
}

@end
