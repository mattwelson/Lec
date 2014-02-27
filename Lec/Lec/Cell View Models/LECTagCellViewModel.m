//
//  LECTagCellViewModel.m
//  Lec
//
//  Created by Matt Welson on 9/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECTagCellViewModel.h"
#import "Tag.h"

@implementation LECTagCellViewModel

+(instancetype)tagCellVMWithTag:(Tag *)tag andColour:(NSString *)colourString
{
    LECTagCellViewModel *cellViewModel = [[LECTagCellViewModel alloc] init];
    
    cellViewModel.tag = tag;
    cellViewModel.time = tag.currentTime;
    cellViewModel.colourString = colourString;
    cellViewModel.tintColour = [[LECColourService sharedColourService] baseColourFor:colourString];
    cellViewModel.titleText = [tag name];
    cellViewModel.subText = [NSString stringWithFormat:@"Time: %@", [tag currentTime]];
    return cellViewModel;
}

@end
