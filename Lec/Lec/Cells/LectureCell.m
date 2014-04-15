//
//  LectureCell.m
//  Lec
//
//  Created by Matt Welson on 27/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LectureCell.h"

@implementation LectureCell

static void * localContext = &localContext;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.courseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.frame.size.width-80, 40)];
        self.courseNameLabel.textColor = [UIColor whiteColor];
        self.courseNameLabel.font = [UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE];
        [self.contentView addSubview:self.courseNameLabel];
        
        self.courseDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, self.frame.size.width-60, 40)];
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
    self.vm = vm;
    self.courseNameLabel.text = [vm titleText];
    self.courseDescriptionLabel.text = [vm subText];
    self.courseDescriptionLabel.textColor = [[LECColourService sharedColourService] highlightColourFor:vm.colourString];
    self.courseNameLabel.textColor = [[LECColourService sharedColourService] baseColourFor:vm.colourString];
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self setupObservingOf:vm];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [self deallocObservation:self.vm];
}

#pragma mark - KVO
// seperated off as it's ugly as shit
-(void) setupObservingOf:(LECLectureCellViewModel *)vm
{
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(subText)) options:NSKeyValueObservingOptionNew context:localContext];
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(titleText)) options:NSKeyValueObservingOptionNew context:localContext];
}

-(void)deallocObservation:(LECLectureCellViewModel *)vm;
{
    @try {
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(subText))];
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(titleText))];
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
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(subText))])
    {
        self.courseDescriptionLabel.text = change[NSKeyValueChangeNewKey];
    }
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(titleText))])
    {
        self.courseNameLabel.text = change[NSKeyValueChangeNewKey];
    }
}

@end
