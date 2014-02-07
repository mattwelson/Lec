//
//  LECParallaxService.m
//  Lec
//
//  Created by Julin Le-Ngoc on 8/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECParallaxService.h"

@implementation LECParallaxService

static LECParallaxService *sharedService;

+ (LECParallaxService *) sharedParallaxService
{
    if (sharedService) return sharedService;
    
    sharedService = [[LECParallaxService alloc] init];
    return sharedService;
}

-(void)addParallaxToView:(UIView *)view {
    
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.25f;
    view.layer.shadowRadius = 4.0f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);
    
    UIInterpolatingMotionEffect *shadowEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    shadowEffect.minimumRelativeValue = [NSValue valueWithCGSize:CGSizeMake(20, 5)];
    shadowEffect.maximumRelativeValue = [NSValue valueWithCGSize:CGSizeMake(-20, 5)];
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect, shadowEffect];
    
    [view addMotionEffect:group];
    
}

@end
