//
//  LECColourService.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECColourService.h"

@implementation LECColourService

-(LECColourService *) init
{
    self = [super init];
    if (self)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Colours" ofType:@"plist"];
        self.colourDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return self;
}

+(LECColourService *)colourService
{
    return [[LECColourService alloc] init];
}

-(UIColor *) baseColourFor:(NSString *)colourName
{
    return [self colourFor:colourName forKey:@"BaseColour"];
}

-(UIColor *) highlightColourFor:(NSString *)colourName
{
    return [self colourFor:colourName forKey:@"HighlightColour"];
}

-(UIColor *) colourFor:(NSString *)colourName forKey:(NSString *)key
{
    NSDictionary *colourValues = [[[self colourDictionary] valueForKey:colourName] valueForKey:key];
    CGFloat r = [[colourValues valueForKey:@"RValue"] floatValue] /255;
    CGFloat g = [[colourValues valueForKey:@"GValue"] floatValue] /255;
    CGFloat b = [[colourValues valueForKey:@"BValue"] floatValue] /255;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

// need to set gradient layer to size [gradient setFrame:rect];
// then insert into view - [[self layer] insertSublayer:gradient atIndex:0];
-(void) addGradientForColour:(NSString *)colour toView:(UIView *)view
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setColors:[NSArray arrayWithObjects:
                         (id)[[self highlightColourFor:colour] CGColor],
                         (id)[[self baseColourFor:colour] CGColor], nil]];
    [gradient setFrame:[view frame]];
    [[view layer] insertSublayer:gradient atIndex:0];
}
@end