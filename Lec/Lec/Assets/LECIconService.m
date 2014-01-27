//
//  LECIconService.m
//  Lec
//
//  Created by Julin Le-Ngoc on 27/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECIconService.h"

@implementation LECIconService

static LECIconService *sharedService;

-(LECIconService *) init
{
    self = [super init];
    if (self)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Icons" ofType:@"plist"];
        self.iconDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return self;
}

+ (LECIconService *) sharedColourService
{
    if (sharedService) return sharedService;
    
    sharedService = [[LECIconService alloc] init];
    return sharedService;
}

-(NSArray *)iconKeys
{
    return [[sharedService iconDictionary] allKeys];
}

-(void) addIcon:(NSString *)icon toView:(UIView *)view{
    
}


@end
