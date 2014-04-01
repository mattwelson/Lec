//
//  LECPlaybackControls.h
//  Lec
//
//  Created by Julin Le-Ngoc on 28/03/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECDefines.h"
#import "LECLectureViewModel.h"

@protocol PlaybackControlDelegate <NSObject>

-(void) tagButtonPressed;

@end

@interface LECPlaybackControls : UIView

@property LECLectureViewModel *viewModel;

@property UIButton *splitTagButton;
@property UIButton *playPauseButton;
@property UIButton *fastForwardButton;
@property UIButton *rewindButton;
@property UIButton *twoTimesForwardButton;
@property (nonatomic, assign) id<PlaybackControlDelegate> playbackDelegate;


- (id)initWithFrame:(CGRect)frame andWithViewModel:(LECLectureViewModel *)vm;
+(id)playbackControlSetup;


@end
