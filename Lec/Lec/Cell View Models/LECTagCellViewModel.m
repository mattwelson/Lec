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

static void * localContext = &localContext;

+(instancetype)tagCellVMWithTag:(Tag *)tag andColour:(NSString *)colourString
{
    LECTagCellViewModel *cellViewModel = [[LECTagCellViewModel alloc] init];
    
    cellViewModel.tag = tag;
    cellViewModel.time = tag.currentTime;
    cellViewModel.colourString = colourString;
    cellViewModel.tintColour = [[LECColourService sharedColourService] baseColourFor:colourString];
    cellViewModel.titleText = [tag name];
    cellViewModel.subText = [NSString stringWithFormat:@"Time: %@", [tag currentTime]];
    
    [cellViewModel setupObservation];
    return cellViewModel;
}

-(void) setupObservation
{
    [self.tag addObserver:self forKeyPath:NSStringFromSelector(@selector(name)) options:NSKeyValueObservingOptionNew context:localContext];
}

-(void)deallocObservation
{
    @try {
        [self.tag removeObserver:self forKeyPath:NSStringFromSelector(@selector(name))];
    }
    @catch (NSException * __unused exception) {}
}

// Updates view model when the managed object changes (tag descriptions on playback screen)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != localContext) return;
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(name))])
    {
        self.titleText = change[NSKeyValueChangeNewKey];
    }
    if (change[NSKeyValueChangeNewKey] == [NSNull null]) [self deallocObservation];
}
@end
