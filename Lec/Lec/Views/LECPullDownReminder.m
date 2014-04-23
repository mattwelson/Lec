//
//  LECPullDownReminder.m
//  Lec
//
//  Created by Julin Le-Ngoc on 20/04/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECPullDownReminder.h"

@implementation LECPullDownReminder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id)createReminderViewMainScreen
{
    LECPullDownReminder *pullDownScreen = [[LECPullDownReminder alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, (pullDownScreen.frame.size.height/2)-100, SCREEN_WIDTH-30, 100)];
    label.text = @"Pull down to create a new course, or press the + button.";
    label.font = [UIFont fontWithName:DEFAULTFONT size:20];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [pullDownScreen addSubview:label];
    return pullDownScreen;
}

+(id)createReminderViewCourseScreen
{
    LECPullDownReminder *pullDownScreen = [[LECPullDownReminder alloc]initWithFrame:CGRectMake(0, 136, SCREEN_WIDTH, SCREEN_HEIGHT-136)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH-30, 100)];
    NSLog(@"HEIGHT: %f", pullDownScreen.frame.size.height);
    label.text = @"Pull down to create a new lecture.";
    label.font = [UIFont fontWithName:DEFAULTFONT size:20];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [pullDownScreen addSubview:label];
    return pullDownScreen;
}

@end
