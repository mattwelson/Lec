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
    
    [course addObserver:courseCellModel forKeyPath:NSStringFromSelector(@selector(colour)) options:NSKeyValueObservingOptionNew context:localContext];
    
    return courseCellModel;
}

// Updates view model when the managed object changes (edit screen)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != localContext) return;
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(colour))])
    {
        self.colourString = change[NSKeyValueChangeNewKey];
    }
}

@end
