//
//  LECTagCellViewModel.h
//  Lec
//
//  Created by Matt Welson on 9/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECBaseCellViewModel.h"

@class Tag;

@interface LECTagCellViewModel : LECBaseCellViewModel

@property Tag *tag;
@property NSNumber *time;

+(instancetype)tagCellVMWithTag:(Tag *)tag andColour:(NSString *)colourString;

@end
