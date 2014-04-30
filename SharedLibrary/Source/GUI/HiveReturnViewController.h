//
//  HiveReturnViewController.h
//  HiveReturn
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#include "SharedLibraryInterface.h"
#include "SharedLibraryHeader.h"

@interface HiveReturnViewController : UIViewController
{
    SharedLibraryInterface*     backEndInterface;
    
    bool m_bToggleStartStatus;
    bool m_bToggleVibratoStatus;
    bool m_bTogglePitchShiftStatus;
    bool m_bToggleDelayStatus;
    bool m_bToggleLowpassStatus;
    
    float m_fGainValue;
    
    bool m_bAccelerometerTriggerStatus;
    bool m_bAccelerometerTriggerPreviousStatus;
    int m_iAccelerometerTriggerCounter;
    
    bool m_bLeftFrontTriggerStatus;
    bool m_bLeftFrontTriggerPreviousStatus;
    int m_iLeftFrontTriggerCounter;
    
    bool m_bRightFrontTriggerStatus;
    bool m_bRightFrontTriggerPreviousStatus;
    int m_iRightFrontTriggerCounter;
    
    bool m_bLeftBackTriggerStatus;
    bool m_bLeftBackTriggerPreviousStatus;
    int m_iLeftBackTriggerCounter;
    
    bool m_bRightBackTriggerStatus;
    bool m_bRightBackTriggerPreviousStatus;
    int m_iRightBackTriggerCounter;
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
