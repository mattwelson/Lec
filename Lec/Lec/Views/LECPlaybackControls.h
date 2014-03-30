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

@interface LECPlaybackControls : UIView

@property LECLectureViewModel *viewModel;

@property UIButton *playPauseButton;
@property UIButton *fastForwardButton;
@property UIButton *rewindButton;
@property UIButton *twoTimesForwardButton;

- (id)initWithFrame:(CGRect)frame andWithViewModel:(LECLectureViewModel *)vm;
+(id)playbackControlSetup;

@end
