//
//  SharedLibraryViewController.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#include "SharedLibraryInterface.h"
#include "SharedLibraryHeader.h"

@interface SharedLibraryViewController : UIViewController
{
    SharedLibraryInterface*     backEndInterface;
    
    bool m_bToggleStartStatus;
    bool m_bToggleVibratoStatus;
    bool m_bTogglePitchShiftStatus;
    bool m_bToggleDelayStatus;
    bool m_bToggleLowpassStatus;
    
    float m_fGainValue;
}

// Core Motion
@property (nonatomic, strong) CMMotionManager* motionManager;
- (void) motionDeviceUpdate:(CMDeviceMotion *)deviceMotion;

// GUI
@property (retain, nonatomic) IBOutlet UIButton *toggleStartButton;
- (IBAction)toggleStartButtonClicked:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UIButton *toggleVibratoButton;
- (IBAction)toggleVibratoButtonClicked:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UIButton *togglePitchShiftButton;
- (IBAction)togglePitchShiftButtonClicked:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UIButton *toggleDelayButton;
- (IBAction)toggleDelayButtonClicked:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UIButton *toggleLowpassButton;
- (IBAction)toggleLowpassButtonClicked:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UISlider *gainSlider;
- (IBAction)gainSliderChanged:(UISlider *)sender;



@end
