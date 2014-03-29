//
//  LECPlaybackControls.h
//  Lec
//
//  Created by Julin Le-Ngoc on 28/03/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECDefines.h"

@interface LECPlaybackControls : UIView

@property UIButton *playPauseButton;
@property UIButton *fastForwardButton;
@property UIButton *rewindButton;
@property UIButton *twoTimesForwardButton;

+(id)playbackControlSetup;

@end
