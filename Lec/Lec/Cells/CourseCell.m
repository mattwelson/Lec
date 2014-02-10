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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
