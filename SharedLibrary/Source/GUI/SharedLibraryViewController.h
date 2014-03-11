//
//  SharedLibraryViewController.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "SharedLibraryInterface.h"

@interface SharedLibraryViewController : UIViewController
{
    SharedLibraryInterface*     backEndInterface;
    
    bool m_bAudioToggleStatus;
    int  m_iRecordPlaybackStatus;
}



@property (retain, nonatomic) IBOutlet UIButton *toggleAudioButton;
- (IBAction)toggleAudioButtonClicked:(UIButton *)sender;




@end
