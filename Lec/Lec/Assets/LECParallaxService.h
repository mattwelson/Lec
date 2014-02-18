//
//  LECParallaxService.h
//  Lec
//
//  Created by Julin Le-Ngoc on 8/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LECParallaxService : NSObject

+ (LECParallaxService *)sharedParallaxService;

-(void)addParallaxToView:(UIView *)view strength:(int)strength;

@end
