//
//  SharedLibraryViewController.m
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "SharedLibraryViewController.h"

@interface SharedLibraryViewController ()

@end

@implementation SharedLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    backEndInterface    =   new SharedLibraryInterface;
    m_bAudioToggleStatus = false;
    m_iRecordPlaybackStatus = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleAudioButtonClicked:(UIButton *)sender
{
    if (!m_bAudioToggleStatus)
    {
        backEndInterface->toggleAudioButtonClicked(true);
        m_bAudioToggleStatus    =   true;
    }
    else
    {
        backEndInterface->toggleAudioButtonClicked(false);
        m_bAudioToggleStatus    =   false;
    }
    
}


- (void)dealloc
{
    
    [_toggleAudioButton release];
    
        
    delete backEndInterface;
    
    [super dealloc];
}
@end
