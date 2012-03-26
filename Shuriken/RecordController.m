//
//  RecordController.m
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecordController.h"
#import "RecordManager.h"
#import "Record.h"
#import "RecordCell.h"
#import "CustomLabelUtil.h"

@implementation RecordController
@synthesize records;
@synthesize clearRecordsButton;
@synthesize backButton;
@synthesize winsTitle;
@synthesize loseTitle;
@synthesize fleeTitle;
@synthesize winCount;
@synthesize loseCount;
@synthesize fleeCount;

- (void)initTitles
{   
    self.winsTitle = [CustomLabelUtil creatWithFrame:CGRectMake(139, 123, 42, 41) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.view text:NSLocalizedString(@"Win", @"胜利") bold:NO];
     self.loseTitle = [CustomLabelUtil creatWithFrame:CGRectMake(80, 153, 42, 41) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.view text:NSLocalizedString(@"Lose", @"战败") bold:NO];
     self.fleeTitle = [CustomLabelUtil creatWithFrame:CGRectMake(199, 153, 42, 41) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.view text:NSLocalizedString(@"Flee", @"逃跑") bold:NO];
    
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 91, 50) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.backButton text:NSLocalizedString(@"back", @"退出") bold:NO];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 91, 50) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.clearRecordsButton text:NSLocalizedString(@"clear", @"清空") bold:NO];
}

- (void)initDatas
{
    NSString* winCountStr = [NSString stringWithFormat:@"%d", [[RecordManager shareInstance] getWinCount]];
    NSString* loseCountStr = [NSString stringWithFormat:@"%d", [[RecordManager shareInstance] getLoseCount]];
    NSString* fleeCountStr = [NSString stringWithFormat:@"%d", [[RecordManager shareInstance] getFleeCount]];
    
    self.winCount = [CustomLabelUtil creatWithFrame:CGRectMake(139, 95, 42, 41) pointSize:20 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.view text:winCountStr bold:NO];
    self.loseCount = [CustomLabelUtil creatWithFrame:CGRectMake(81, 132, 42, 41) pointSize:20 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.view text:loseCountStr bold:NO];
    self.fleeCount = [CustomLabelUtil creatWithFrame:CGRectMake(199, 132, 42, 41) pointSize:20 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.view text:fleeCountStr bold:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitles];
    [self initDatas];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setRecords:nil];
    [self setClearRecordsButton:nil];
    [self setWinsTitle:nil];
    [self setLoseTitle:nil];
    [self setFleeTitle:nil];
    [self setWinCount:nil];
    [self setLoseCount:nil];
    [self setFleeCount:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backToEntry:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [records release];
    [clearRecordsButton release];
    [winsTitle release];
    [loseTitle release];
    [fleeTitle release];
    [winCount release];
    [loseCount release];
    [fleeCount release];
    [backButton release];
    [super dealloc];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[RecordManager shareInstance].recordArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RecordCell createRecordCell];
        
    }
    Record* aRecord = [[RecordManager shareInstance].recordArray objectAtIndex:indexPath.row];
    [cell setCellWithRecord:aRecord];
    
    return cell;
}

#pragma mark - alert view delegate
#define OK_INDEX 1
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case OK_INDEX:
            [[RecordManager shareInstance] clearAllRecords];
            [self.records reloadData];
            [self initDatas];
            break;
        default:
            break;
    }
}

- (IBAction)clickClear:(id)sender
{
    UIAlertView* view = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure?", @"真的要清除？") 
                                                    message:NSLocalizedString(@"It will clear all the records!", @"所有战绩都会被删掉！") delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"NO", @"否") 
                                          otherButtonTitles:NSLocalizedString(@"YES", @"是"), nil] autorelease];
    
    [view show];
}


@end
