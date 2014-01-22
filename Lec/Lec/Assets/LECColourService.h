//
//  LECColourService.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LECColourService : NSObject

@property NSDictionary *colourDictionary;

+ (LECColourService *)sharedColourService;

-(UIColor *) baseColourFor:(NSString *)colourName;
-(UIColor *) highlightColourFor:(NSString *)colourName;
-(UIColor *) colourFor:(NSString *)colourName forKey:(NSString *)key;
-(void) addGradientForColour:(NSString *)colour toView:(UIView *)view;

@end
