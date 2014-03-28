//
//  LECPlaybackControls.m
//  Lec
//
//  Created by Julin Le-Ngoc on 28/03/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECPlaybackControls.h"

@implementation LECPlaybackControls

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

+(id)playbackControlSetup
{
    LECPlaybackControls *playbackControl = [[LECPlaybackControls alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 80)];
    
    return playbackControl;
}


@end
