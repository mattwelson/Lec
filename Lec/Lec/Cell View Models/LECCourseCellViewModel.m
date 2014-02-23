//
//  LECCourseCellViewModel.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECCourseCellViewModel.h"

@implementation LECCourseCellViewModel

+(LECCourseCellViewModel *) courseCellWith:(Course *)course
{
    LECCourseCellViewModel *courseCellModel = [[LECCourseCellViewModel alloc] init];
    
    [courseCellModel setCourse:course];
    [courseCellModel setTitleText:[course courseName]];
    [courseCellModel setSubText:[course courseDescription]];
    [courseCellModel setTintColour:[[LECColourService sharedColourService] baseColourFor:[course colour]]];
    [courseCellModel setIcon:[course icon]];
    
    [courseCellModel setColourString:[course colour]];
    
    [course addObserver:self forKeyPath:@"colour" options:NSKeyValueObservingOptionNew context:nil];
    
    return courseCellModel;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}

@end
