//
//  LECPlaybackControls.m
//  Lec
//
//  Created by Julin Le-Ngoc on 28/03/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECPlaybackControls.h"
#import "LECColourService.h"
#import "LECAudioService.h"

@implementation LECPlaybackControls

- (id)initWithFrame:(CGRect)frame andWithViewModel:(LECLectureViewModel *)vm
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewModel = vm;
        self.backgroundColor = [UIColor whiteColor];
        
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
        topBorder.backgroundColor = [[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]].CGColor;
        [self.layer addSublayer:topBorder];
        
        [self setupButtons];
    }
    return self;
}

-(void)setupButtons
{
    self.rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rewindButton.frame = CGRectMake(20, 5, 30, 30);
    [self.rewindButton setImage:[[UIImage imageNamed:@"playback_rewind_btn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.rewindButton setTintColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]]];
    //[self.rewindButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.rewindButton];
    
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playPauseButton.frame = CGRectMake(110, 5, 30, 30);
    if ([[LECAudioService sharedAudioService]isPlaying]) {
        [self.playPauseButton setImage:[[UIImage imageNamed:@"playback_pause_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    else {
        [self.playPauseButton setImage:[[UIImage imageNamed:@"playback_play_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    [self.playPauseButton setTintColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]]];
    [self.playPauseButton addTarget:self action:@selector(playPauseButtonPressed:) forControlEvents:UIControlEventTouchDown];
    //[self.playPauseButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.playPauseButton];
    
    self.fastForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fastForwardButton.frame = CGRectMake(200, 5, 30, 30);
    [self.fastForwardButton setImage:[[UIImage imageNamed:@"playback_fastforward_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.fastForwardButton setTintColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]]];
    //[self.fastForwardButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.fastForwardButton];
    
    self.twoTimesForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.twoTimesForwardButton.frame = CGRectMake(280, 5, 30, 30);
    [self.twoTimesForwardButton setTitle:@"2x" forState:UIControlStateNormal];
    [self.twoTimesForwardButton.titleLabel setFont:[UIFont fontWithName:DEFAULTFONT size:18]];
    [self.twoTimesForwardButton.titleLabel setTextColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]]];

    //[self.twoTimesForwardButton setImage:[UIImage imageNamed:@"playback_fastforward_btn.png"] forState:UIControlStateNormal];
    [self addSubview:self.twoTimesForwardButton];
}

//TODO: add the delegate for when playback finishes to change the button
-(void)playPauseButtonPressed:(id)sender{
    if ([[LECAudioService sharedAudioService]isPlaying]) {
        [[LECAudioService sharedAudioService]pausePlayback];
        [self.playPauseButton setImage:[[UIImage imageNamed:@"playback_play_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    else {
        [[LECAudioService sharedAudioService]resumePlayback];
        [self.playPauseButton setImage:[[UIImage imageNamed:@"playback_pause_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
}

+(id)playbackControlSetup
{
    LECPlaybackControls *playbackControl = [[LECPlaybackControls alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 80)];
    
    return playbackControl;
}


@end
