//
//  EntryController.m
//  Shuriken
//
//  Created by Orange on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EntryController.h"
#import "SKCommonMultiPlayerService.h"
#import "GameController.h"

@implementation EntryController

- (void)dealloc
{
    [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)findDevice:(id)sender
{
    SKCommonMultiPlayerService* servcie = [[SKCommonMultiPlayerService alloc] init];
    GameController* vc = [[GameController alloc] initWithMultiPlayerService:servcie];
    [self.navigationController pushViewController:vc animated:YES];
    [servcie release];
    [vc release];
}

- (IBAction)testGame:(id)sender
{
    GameController* sc =  [[GameController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
    [sc release];
}

@end
