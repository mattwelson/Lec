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
        self.courseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.frame.size.width-80, 40)];
        self.courseNameLabel.textColor = [UIColor whiteColor];
        self.courseNameLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE];
        [self.contentView addSubview:self.courseNameLabel];
        
        self.courseDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, self.frame.size.width-80, 40)];
        self.courseDescriptionLabel.textColor = [UIColor whiteColor];
        self.courseDescriptionLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSEDESCRIPTIONCELLFONTSIZE];
        [self.contentView addSubview:self.courseDescriptionLabel];
        
        CGRect frame = [self frame];
        frame.size.height = 75;
        [self setFrame:frame];
        [[self contentView] setFrame:frame];
    }
    return self;
}

-(void)populateFor:(LECLectureCellViewModel *)vm
{
    self.courseNameLabel.text = [vm titleText];
    self.courseDescriptionLabel.text = [vm subText];
    self.courseDescriptionLabel.textColor = [[LECColourService sharedColourService] highlightColourFor:vm.colourString];
    self.courseNameLabel.textColor = [[LECColourService sharedColourService] baseColourFor:vm.colourString];
    self.backgroundColor = [UIColor whiteColor];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
