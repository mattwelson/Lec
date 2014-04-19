//
//  LECLectureViewModel.m
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECLectureViewModel.h"
#import "LECAudioService.h"
#import "LECDefines.h"
#import "LECTagCellViewModel.h"

@implementation LECLectureViewModel
{
    long cTag; // HACK because wouldn't build with _currentTag :(
    NSMutableArray *tagTimes;
}

+(LECLectureViewModel *)viewModelWithLecture:(Lecture *)lecture
{
    LECLectureViewModel *vm = [[LECLectureViewModel alloc] init];
    vm.lecture = lecture;
    vm.icon = lecture.course.icon;
    vm.colourString = lecture.course.colour;
    vm.navTitle = [lecture lectureName];
    vm.subTitle = [NSString stringWithFormat:@"Lecture %@", [lecture lectureNumber]];
    
    vm.courseName = [[lecture course] courseName];
    
    vm.recordingPath = [lecture recordingPath] ;
    if (!vm.recordingPath) {
        [vm setInitialRecordingPath];
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(currentTime)) ascending:YES];
    NSArray *sortedTags = [lecture.tags sortedArrayUsingDescriptors:@[sortDescriptor]];
    for (Tag *tag in sortedTags)
    {
        [vm.tableData addObject:[LECTagCellViewModel tagCellVMWithTag:tag andColour:vm.colourString]];
    }
    
    vm.canTag = YES;
    return vm;
}

#pragma mark Recording
-(void) setInitialRecordingPath
{
    NSString *recordingPath= [NSString stringWithFormat:@"%@_%@_%@",self.courseName, self.subTitle, self.navTitle];
    self.recordingPath = [[recordingPath stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingPathExtension:FILE_RECORDING_TYPE];
    
    self.lecture.recordingPath = self.recordingPath;
    [[LECDatabaseService sharedDBService] saveChanges];
}

-(void)prepareForRecordingAudio
{
    [[LECAudioService sharedAudioService] setupAudioRecordingForPath:[self recordingPath]];
}

-(void)startRecordingAudio
{
    [[LECAudioService sharedAudioService] startRecording];
    [self insertTagAtStart];
}

-(void)stopRecordingAudio
{
    [[LECAudioService sharedAudioService] stopRecording];
}

-(void) addTagToCurrentTime
{
    Tag *tag = [[LECDatabaseService sharedDBService] newTagForLecture:self.lecture];
    tag.currentTime = [[LECAudioService sharedAudioService] getCurrentTime];
    tag.name = @"Hi, I'm a tag";
    [[LECDatabaseService sharedDBService] saveChanges];
    [self.tableData addObject:[LECTagCellViewModel tagCellVMWithTag:tag andColour:self.colourString]];
}

#pragma mark Playback
-(void) prepareForPlaybackWithCompletion:(void (^)(void))block
{
    [[LECAudioService sharedAudioService] setupAudioPlayback:[self recordingPath] withCompletion:block];
    self.currentTag = 0;
    [[LECAudioService sharedAudioService] setDelegate:self];
    tagTimes = [NSMutableArray array];
    [self.tableData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [tagTimes addObject:[(LECTagCellViewModel *)obj time]];
    }];
}

-(void) startAudioPlayback
{
    [[LECAudioService sharedAudioService] startPlayback];
}

-(void) stopAudioPlayback
{
    [[LECAudioService sharedAudioService] stopPlayback];
}

-(BOOL) audioIsPlaying
{
    return [[LECAudioService sharedAudioService] isAudioPlaying];
}

-(void)goToTag:(NSInteger)index
{
    self.canTag = YES;
    LECTagCellViewModel *tagCVM = self.tableData[index];
    [[LECAudioService sharedAudioService] goToTime:[tagCVM time]];

    self.currentTag = index;
}

-(void)goToTagVisually:(NSInteger)index
{
    for (int i = 0; i < [self.tableData count]; i ++)
    {
        if (i < index)
        {
            ((LECTagCellViewModel *)self.tableData[i]).playState = hasPlayed;
        }
        else if (i > index)
        {
            ((LECTagCellViewModel *)self.tableData[i]).playState = notPlayed;
        }
        else
        {
            ((LECTagCellViewModel *)self.tableData[i]).playState = isPlaying;
            ((LECTagCellViewModel *)self.tableData[i]).progress = 0;
        }
    }
    
}

-(BOOL)insertTagAtStart
{
    Tag *tag = [[LECDatabaseService sharedDBService] newTagForLecture:self.lecture];
    tag.currentTime = @0;
    tag.name = @"Intro";
    [[LECDatabaseService sharedDBService] saveChanges];
    LECTagCellViewModel *tagCVM = [LECTagCellViewModel tagCellVMWithTag:tag andColour:self.colourString];
    
    NSUInteger newIndex = [self.tableData indexOfObject:tagCVM inSortedRange:NSMakeRange(0, self.tableData.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(LECTagCellViewModel *obj1, LECTagCellViewModel *obj2) {
        return [obj1.time compare:obj2.time];
    }];
    
    [self.tableData insertObject:tagCVM atIndex:newIndex];
    return YES;
}

-(BOOL)insertTagAtCurrentTime
{
    if (!self.canTag) return NO;
    
    Tag *tag = [[LECDatabaseService sharedDBService] newTagForLecture:self.lecture];
    tag.currentTime = [[LECAudioService sharedAudioService] getCurrentTime];
    tag.name = @"Hi, I'm a PLAYBACK tag";
    [[LECDatabaseService sharedDBService] saveChanges];
    LECTagCellViewModel *tagCVM = [LECTagCellViewModel tagCellVMWithTag:tag andColour:self.colourString];

    NSUInteger newIndex = [self.tableData indexOfObject:tagCVM inSortedRange:NSMakeRange(0, self.tableData.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(LECTagCellViewModel *obj1, LECTagCellViewModel *obj2) {
        return [obj1.time compare:obj2.time];
    }];
    
    [self.tableData insertObject:tagCVM atIndex:newIndex];
    self.currentTag = self.currentTag + 1;
    return YES;
}

#pragma mark - Crazy tag shit
-(void)playbackIsAtTime:(double)time
{
    // check if time is outside the current tags boundaries.
    if (time < self.currentTagStartTime || time > self.currentTagFinishTime) {
        self.currentTag =
        [tagTimes indexOfObject:@(time) inSortedRange:NSMakeRange(0, tagTimes.count) options:NSBinarySearchingInsertionIndex usingComparator:^(NSNumber *obj1, NSNumber *obj2){
            return [obj1 compare:obj2];
        }] - 1;
    }
    CGFloat progress = (time - self.currentTagStartTime) / (self.currentTagFinishTime - self.currentTagStartTime);

    [self setCurrentTagProgress:progress];
    //NSLog(@"%f", progress);
}

-(void)setCurrentTagProgress:(CGFloat)progress
{
    [(LECTagCellViewModel *)[self.tableData objectAtIndex:self.currentTag] setProgress:progress];
    [self.delegate reloadCellAtIndex:self.currentTag];
}

-(void)setCurrentTag:(long)currentTag
{
    cTag = currentTag;
    self.currentTagStartTime = [[(LECTagCellViewModel *)[self.tableData objectAtIndex:self.currentTag] time] doubleValue];
    if (self.currentTag < self.tableData.count - 1 ) { // is not the last tag
        self.currentTagFinishTime = [[(LECTagCellViewModel *)[self.tableData objectAtIndex:self.currentTag+1] time] doubleValue];
    } else {
        self.currentTagFinishTime = [[LECAudioService sharedAudioService] getRecordingLength];
    }
    
    [self goToTagVisually:currentTag];
}

-(long)currentTag
{
    return cTag;
}
@end
