//
//  LECViewController.m
//  TableSelection
//
//  Created by Matt Welson on 11/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECViewController.h"

@interface LECViewController ()

@end

@implementation LECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.CellModelArray = [NSArray arrayWithObjects:
                           [LECCellModel cellUnselected],
                           [LECCellModel cellUnselected],
                           [LECCellModel cellUnselected],
                           [LECCellModel cellUnselected],
                           [LECCellModel cellUnselected],
                           [LECCellModel cellUnselected],
                           nil];
    self.color = [[self view] backgroundColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self CellModelArray] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *lecTableIdentifier = @"lecTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lecTableIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lecTableIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Tag %d", indexPath.row];
    cell.backgroundColor = [(LECCellModel *)[self.CellModelArray objectAtIndex:indexPath.row] selected] ? self.color : [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = 0;
    while (i <= indexPath.row)
    {
        [[self.CellModelArray objectAtIndex:i] setSelected:YES];
        i++;
    }
    while (i < [self.CellModelArray count])
    {
        [[self.CellModelArray objectAtIndex:i] setSelected:NO];
        i++;
    }
    [tableView reloadData];
}
@end
