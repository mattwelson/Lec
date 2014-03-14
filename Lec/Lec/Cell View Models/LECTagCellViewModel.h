//
//  LECTagCellViewModel.h
//  Lec
//
//  Created by Matt Welson on 9/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECBaseCellViewModel.h"

typedef enum {
    isPlaying,
    hasPlayed,
    notPlayed
} PlayStateType;

@class Tag;

@interface LECTagCellViewModel : LECBaseCellViewModel

@property Tag *tag;
@property NSNumber *time;
@property PlayStateType playState;

+(instancetype)tagCellVMWithTag:(Tag *)tag andColour:(NSString *)colourString;
-(CGFloat)progressPercentage;

@end
