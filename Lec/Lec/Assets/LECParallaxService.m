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

-(void)addParallaxToView:(UIView *)view strength:(int)strength{
    int parallaxStrength;
    CGSize shadowStrengthMin = CGSizeZero;
    CGSize shadowStrengthMax = CGSizeZero;

    
    switch (strength) {
        case 1:
            parallaxStrength = 15;
            view.layer.shadowColor = [UIColor blackColor].CGColor;
            view.layer.shadowOpacity = 0.25f;
            view.layer.shadowRadius = 4.0f;
            view.layer.shadowOffset = CGSizeMake(0, 0);
            shadowStrengthMin = CGSizeMake(20, 5);
            shadowStrengthMax = CGSizeMake(-20, 5);
            break;
        case 2:
            parallaxStrength = 20;
            view.layer.shadowColor = [UIColor blackColor].CGColor;
            view.layer.shadowOpacity = 0.5f;
            view.layer.shadowRadius = 4.0f;
            view.layer.shadowOffset = CGSizeMake(0, 0);
            shadowStrengthMin = CGSizeMake(30, 5);
            shadowStrengthMax = CGSizeMake(-30, 5);
            break;
        default:
            parallaxStrength = 15;
    }
    

    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-parallaxStrength+5);
    verticalMotionEffect.maximumRelativeValue = @(parallaxStrength-5);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-parallaxStrength);
    horizontalMotionEffect.maximumRelativeValue = @(parallaxStrength);
    
    UIInterpolatingMotionEffect *shadowEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    shadowEffect.minimumRelativeValue = [NSValue valueWithCGSize:shadowStrengthMin];
    shadowEffect.maximumRelativeValue = [NSValue valueWithCGSize:shadowStrengthMax];
    
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect, shadowEffect];
    
    [view addMotionEffect:group];
    
}

@end
