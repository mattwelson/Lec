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
#import "LECAnimationService.h"

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
        
        [self.viewModel prepareForPlaybackWithCompletion:^{
            [self updateButtonImage];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateChanged) name:kPlayStateNotification object:[LECAudioService sharedAudioService]];
        
        [self setupButtons];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setupButtons
{
    
    //-------------Split tag button-------------
    self.splitTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.splitTagButton.frame = CGRectMake(10, self.frame.size.height/2-22, 44, 44);
    [self.splitTagButton setImage:[[UIImage imageNamed:@"icon_bar_tag.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.splitTagButton setTintColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]]];
    [self.splitTagButton addTarget:self action:@selector(splitTagButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.splitTagButton];
    
    //-------------Rewind button-------------
    self.rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rewindButton.frame = CGRectMake(70, self.frame.size.height/2-22, 44, 44);
    [self.rewindButton setImage:[[UIImage imageNamed:@"playback_rewind_btn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.rewindButton setTintColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]]];
    UILongPressGestureRecognizer *rwLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(rewind:)];
    rwLongPress.minimumPressDuration = 0.0;
    [self.rewindButton addGestureRecognizer:rwLongPress];
    //[self.rewindButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.rewindButton];
    
    //-------------Play/pause button-------------
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playPauseButton.frame = CGRectMake(140, self.frame.size.height/2-22, 44, 44);
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
    
    //-------------Fast Forward Button-------------
    self.fastForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fastForwardButton.frame = CGRectMake(210, self.frame.size.height/2-22, 44, 44);
    [self.fastForwardButton setImage:[[UIImage imageNamed:@"playback_fastforward_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.fastForwardButton setTintColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]]];
    UILongPressGestureRecognizer *ffLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(fastForward:)];
    ffLongPress.minimumPressDuration = 0.0;
    [self.fastForwardButton addGestureRecognizer:ffLongPress];
    //[self.fastForwardButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.fastForwardButton];
    
    //-------------Two times forward button-------------
    self.twoTimesForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.twoTimesForwardButton.frame = CGRectMake(280, self.frame.size.height/2-22, 44, 44);
    [self.twoTimesForwardButton setTitle:@"2x" forState:UIControlStateNormal];
    [self.twoTimesForwardButton.titleLabel setFont:[UIFont fontWithName:DEFAULTFONT size:18]];
    //[self.twoTimesForwardButton.titleLabel setTextColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]]];
    [self.twoTimesForwardButton setTitleColor:[[LECColourService sharedColourService] baseColourFor:[self.viewModel colourString]] forState:UIControlStateNormal];
    [self addSubview:self.twoTimesForwardButton];
    
    // disable buttons for initial non-playing state
    [self.twoTimesForwardButton setEnabled:NO];
    [self.splitTagButton setEnabled:NO];
}

-(void)playStateChanged
{
    [self updateButtonImage];
    [self toggleButtons];
}

-(void)toggleButtons
{
    [self.splitTagButton setEnabled:!self.splitTagButton.enabled];
    [self.twoTimesForwardButton setEnabled:!self.twoTimesForwardButton.enabled];
}

-(void)updateButtonImage{
    [UIView animateWithDuration:0.05 animations:^{
        self.playPauseButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            if ([[LECAudioService sharedAudioService]isPlaying]) {
                [self.playPauseButton setImage:[[UIImage imageNamed:@"playback_pause_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                self.playPauseButton.transform = CGAffineTransformMakeScale(1, 1);
            }
            else {
                [self.playPauseButton setImage:[[UIImage imageNamed:@"playback_play_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                self.playPauseButton.transform = CGAffineTransformMakeScale(1, 1);
            }
        }];
    }];
}

#pragma mark Buttons and Shit
-(void)splitTagButtonPressed:(id)sender{
    [self.playbackDelegate tagButtonPressed];
}

-(void)playPauseButtonPressed:(id)sender{
    if ([[LECAudioService sharedAudioService]isPlaying]) {
        [[LECAudioService sharedAudioService]pausePlayback];
    }
    else {
        [[LECAudioService sharedAudioService]startPlayback];
    }
}

-(void)fastForward:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [[LECAudioService sharedAudioService]speedUpPlaybackRate];
        self.fastForwardButton.transform = CGAffineTransformMakeScale(1.75, 1.75);

    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [[LECAudioService sharedAudioService]normalPlaybackRate];
        self.fastForwardButton.transform = CGAffineTransformMakeScale(1, 1);

    }
}

-(void)rewind:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [[LECAudioService sharedAudioService]rewindPlaybackRate];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        [[LECAudioService sharedAudioService]normalPlaybackRate];
    }
}

+(id)playbackControlSetup
{
    LECPlaybackControls *playbackControl = [[LECPlaybackControls alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 80)];
    
    return playbackControl;
}


@end
