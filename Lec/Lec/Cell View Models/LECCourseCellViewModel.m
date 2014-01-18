//
//  LECCourseCellViewModel.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECCourseCellViewModel.h"

@implementation LECCourseCellViewModel

+(LECCourseCellViewModel *) courseCellWith:(Course *)course andColourService:(LECColourService *)cservice
{
    LECCourseCellViewModel *courseCellModel = [[LECCourseCellViewModel alloc] init];
    
    [courseCellModel setCourse:course];
    [courseCellModel setTitleText:[course courseName]];
    [courseCellModel setSubText:[course courseDescription]];
    [courseCellModel setTintColour:[cservice baseColourFor:[course colour]]];
    
    [courseCellModel setColourService:cservice];
    
    return courseCellModel;
}

+(LECCourseCellViewModel *) courseCellWithDummy:(LECDummyCourse *)course andColourService:(LECColourService *)cservice
{
    LECCourseCellViewModel *courseCellModel = [[LECCourseCellViewModel alloc] init];
    
    [courseCellModel setCourse:nil];
    [courseCellModel setTitleText:[course courseName]];
    [courseCellModel setSubText:[course courseDescription]];
    //[courseCellModel setTintColor:[cservice baseColourFor:[course colour]]];
    
    [courseCellModel setColourService:cservice];
    [courseCellModel setColourString:[course colour]];
    
    return courseCellModel;
}

@end
