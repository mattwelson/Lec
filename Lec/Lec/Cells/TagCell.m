//
//  TagCell.m
//  Lec
//
//  Created by Matt Welson on 26/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "TagCell.h"
#import "LECDefines.h"

@implementation TagCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.tagNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.frame.size.width-80, 40)];
        self.tagNameLabel.textColor = [UIColor whiteColor];
        self.tagNameLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE];
        [self.contentView addSubview:self.tagNameLabel];
        
        self.tagDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, self.frame.size.width-80, 40)];
        self.tagDescriptionLabel.textColor = [UIColor whiteColor];
        self.tagDescriptionLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSEDESCRIPTIONCELLFONTSIZE];
        [self.contentView addSubview:self.tagDescriptionLabel];
        
        self.progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 0, 2)];
        [self addSubview:self.progressBar];
        self.progressBar.layer.anchorPoint = CGPointZero;
        
        CGRect frame = [self frame];
        frame.size.height = 75;
        [self setFrame:frame];
        [[self contentView] setFrame:frame];
    }
    return self;
}

-(void)populateFor:(LECTagCellViewModel *)vm
{
    self.tagNameLabel.text = [vm titleText];
    self.tagDescriptionLabel.text = [vm subText];
    self.tagDescriptionLabel.textColor = [[LECColourService sharedColourService] highlightColourFor:vm.colourString];
    self.tagNameLabel.textColor = [[LECColourService sharedColourService] baseColourFor:vm.colourString];
    self.backgroundColor = [UIColor whiteColor];
    [self.progressBar setBackgroundColor:[[LECColourService sharedColourService] baseColourFor:vm.colourString]];
    
    [vm setDelegate:self];
    [vm setViewToAnimate:self.progressBar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)renderProgressBar:(CGFloat)percentage
{
    [self.progressBar removeFromSuperview];
    CGRect frame = self.progressBar.frame;
    frame.size.width = SCREEN_WIDTH * percentage;
    [self.progressBar setFrame:frame];
    [self addSubview:self.progressBar];
}

-(void)animateWithAnimation:(CABasicAnimation *)animation
{
    [self.progressBar.layer addAnimation:animation forKey:@"tagAnimation"];
}

@end
