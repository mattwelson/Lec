//
//  CourseCell.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "CourseCell.h"
#import "LECDefines.h"
#import "LECCourseCellViewModel.h"
#import "LECParallaxService.h"

@implementation CourseCell

static void * localContext = &localContext;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 101)];
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
        
        self.courseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, self.frame.size.width-80, 40)];
        self.courseNameLabel.textColor = [UIColor whiteColor];
        self.courseNameLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE];
        [self.contentView addSubview:self.courseNameLabel];
        
        self.courseDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(82, 50, self.frame.size.width-80, 40)];
        self.courseDescriptionLabel.textColor = [UIColor whiteColor];
        self.courseDescriptionLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSEDESCRIPTIONCELLFONTSIZE];
        [self.contentView addSubview:self.courseDescriptionLabel];
        
        self.iconImage = [UIImageView new];
        [self.iconImage setTintColor:[UIColor whiteColor]];
        [self.iconImage setFrame:CGRectMake(15, 25, 50, 50)];
        [self.contentView addSubview:self.iconImage];
        
        CGRect frame = [self frame];
        frame.size.height = 101;
        [self setFrame:frame];
        [[self contentView] setFrame:frame];
        
        if(PARALLAX_ON) {
            [[LECParallaxService sharedParallaxService]addParallaxToView:self.courseNameLabel strength:1];
            [[LECParallaxService sharedParallaxService]addParallaxToView:self.courseDescriptionLabel strength:1];
            [[LECParallaxService sharedParallaxService]addParallaxToView:self.iconImage strength:1];
        }
    }
    return self;
}

-(void)populateFor:(LECCourseCellViewModel *)vm
{
    self.courseNameLabel.text = [vm titleText];
    self.courseDescriptionLabel.text = [vm subText];
    [[LECIconService sharedIconService] retrieveIcon:[vm icon] toView:self.iconImage];
    [[LECColourService sharedColourService] addGradientForColour:[vm colourString] toView:self.backgroundView];
    
    self.selectedView = [[UIView alloc]init];
    self.selectedView.backgroundColor = [[LECColourService sharedColourService]highlightColourFor:[vm colourString]];
    self.selectedBackgroundView = self.selectedView;
    
    [self setupObservingOf:vm];
}

#pragma mark - KVO
// seperated off as it's ugly as shit
-(void) setupObservingOf:(LECCourseCellViewModel *)vm
{
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(colourString)) options:NSKeyValueObservingOptionNew context:localContext];
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(icon)) options:NSKeyValueObservingOptionNew context:localContext];
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(titleText)) options:NSKeyValueObservingOptionNew context:localContext];
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(subText)) options:NSKeyValueObservingOptionNew context:localContext];

}

-(void)deallocObservation:(LECCourseCellViewModel *)vm;
{
    @try {
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(colourString))];
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(icon))];
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(titleText))];
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(subText))];
    }
    @catch (NSException * __unused exception) {}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // sanity check to ensure subclassing hasn't screwed us over, best practice
    if (context != localContext) return;
    if ([NSNull null] == change[NSKeyValueChangeNewKey])
    {
        [self deallocObservation:object];
        return;
    }
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(colourString))])
    {
        [[LECColourService sharedColourService] changeGradientToColour:change[NSKeyValueChangeNewKey] forView:self.backgroundView];
        self.selectedView.backgroundColor = [[LECColourService sharedColourService]highlightColourFor:change[NSKeyValueChangeNewKey]];
        self.selectedBackgroundView = self.selectedView;
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(icon))])
    {
        [[LECIconService sharedIconService] retrieveIcon:change[NSKeyValueChangeNewKey] toView:self.iconImage];
        
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(titleText))])
    {
        self.courseNameLabel.text = change[NSKeyValueChangeNewKey];
        [self.courseNameLabel setNeedsDisplay];
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(subText))])
    {
        self.courseDescriptionLabel.text = change[NSKeyValueChangeNewKey];
        [self.courseDescriptionLabel setNeedsDisplay];
    }
// if icon then change iconImage to match!
}

@end
