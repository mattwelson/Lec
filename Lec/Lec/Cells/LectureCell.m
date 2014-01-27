//
//  LectureCell.m
//  Lec
//
//  Created by Matt Welson on 27/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LectureCell.h"

@implementation LectureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.courseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, self.frame.size.width-80, 40)];
        self.courseNameLabel.textColor = [UIColor whiteColor];
        self.courseNameLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE];
        [self addSubview:self.courseNameLabel];
        
        self.courseDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, self.frame.size.width-80, 40)];
        self.courseDescriptionLabel.textColor = [UIColor whiteColor];
        self.courseDescriptionLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSEDESCRIPTIONCELLFONTSIZE];
        [self addSubview:self.courseDescriptionLabel];
        
        CGRect frame = [self frame];
        frame.size.height = 100;
        [self setFrame:frame];
        [[self contentView] setFrame:frame];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
