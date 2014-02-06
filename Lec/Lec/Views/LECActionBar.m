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
    
    recordBar.colour = [UIColor colorWithRed:0.719 green:0.000 blue:0.008 alpha:1.000];
    recordBar.icon = [UIImage imageNamed:@"icon_mic"];
    
    return recordBar;
}

-(void) setColour:(UIColor *)colour
{
    self.backgroundColor = colour;
    _colour = colour;
}

-(void) setIcon:(UIImage *)icon
{
    [iconView setImage:icon];
    _icon = icon;
}
@end
