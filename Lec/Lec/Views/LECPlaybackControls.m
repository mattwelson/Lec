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
        self.backgroundColor = [UIColor lightGrayColor];
        [self setupButtons];
    }
    return self;
}

-(void)setupButtons
{
    self.rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rewindButton.frame = CGRectMake(20, 5, 30, 30);
    [self.rewindButton setImage:[UIImage imageNamed:@"playback_rewind_btn.png"] forState:UIControlStateNormal];
    [self addSubview:self.rewindButton];
    
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playPauseButton.frame = CGRectMake(110, 5, 30, 30);
    [self.playPauseButton setImage:[UIImage imageNamed:@"playback_play_btn.png"] forState:UIControlStateNormal];
    [self addSubview:self.playPauseButton];
    
    self.fastForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fastForwardButton.frame = CGRectMake(200, 5, 30, 30);
    [self.fastForwardButton setImage:[UIImage imageNamed:@"playback_fastforward_btn.png"] forState:UIControlStateNormal];
    [self addSubview:self.fastForwardButton];
    
    self.twoTimesForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.twoTimesForwardButton.frame = CGRectMake(280, 5, 30, 30);
    [self.twoTimesForwardButton setImage:[UIImage imageNamed:@"playback_fastforward_btn.png"] forState:UIControlStateNormal];
    [self addSubview:self.twoTimesForwardButton];
}

+(id)playbackControlSetup
{
    LECPlaybackControls *playbackControl = [[LECPlaybackControls alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 80)];
    
    return playbackControl;
}


@end
