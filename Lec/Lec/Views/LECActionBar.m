//
//  RecordingBar.m
//  Lec
//
//  Created by Matt Welson on 6/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECActionBar.h"
#import "LECColourService.h"

@implementation LECActionBar {
    UIImageView *iconView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 20, 19, 31)];
        [self addSubview:iconView];
    }
    return self;
}

+(id)recordBar
{
    LECActionBar *recordBar = [[LECActionBar alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
    
    recordBar.colour = [UIColor colorWithRed:0.719 green:0.000 blue:0.008 alpha:1.000]; // TODO: Pass in colour from course
    recordBar.icon = [UIImage imageNamed:@"icon_mic"];
    
    return recordBar;
}

+(id)tagBarWithTarget:(id)target andSelector:(SEL)action
{
    LECActionBar *tagBar = [[LECActionBar alloc] initWithFrame:CGRectMake(0, 0, 320, 75)];
    
    tagBar.colour = [UIColor colorWithRed:0.719 green:0.000 blue:0.008 alpha:1.000]; // TODO: Pass in colour from course
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = tagBar.frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"Tag" forState:UIControlStateNormal];
    [button setTitleColor:tagBar.colour forState:UIControlStateNormal];
    
    [tagBar addSubview:button];
    [tagBar setBackgroundColor:[UIColor whiteColor]];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, tagBar.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [tagBar.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, tagBar.frame.size.height, tagBar.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [tagBar.layer addSublayer:bottomBorder];
    
    return tagBar;
}

-(void) setColour:(UIColor *)colour
{
    iconView.tintColor = colour; // an icon
    _colour = colour;
}

-(void) setIcon:(UIImage *)icon
{
    [iconView setImage:[icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _icon = icon;
}
@end
