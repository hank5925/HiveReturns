//
//  SharedLibraryViewController.m
//  SharedLibrary
//
//  Created by Ying-Shu Kuo on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "SharedLibraryViewController.h"

#define SAMPLE_RATE 0.01

@interface SharedLibraryViewController ()

@end

@implementation SharedLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Motion Manager Initialization
    self.motionManager = [[CMMotionManager alloc] init];
    
    if (!self.motionManager.isDeviceMotionAvailable)
    {
        NSLog(@"Something wrong here...");
        NSLog(@"viewDidLoad <-- SharedLibraryViewController");
        return;
    }
    
    self.motionManager.deviceMotionUpdateInterval = SAMPLE_RATE;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error)
     {
         [self motionDeviceUpdate:deviceMotion];
         if (error)
         {
             NSLog(@"%@", error);
         }
     }
     ];
    
    
    // GUI
    backEndInterface            = new SharedLibraryInterface;
    m_bToggleStartStatus        = false;
    m_bToggleVibratoStatus      = false;
    m_bTogglePitchShiftStatus   = false;
    m_bToggleDelayStatus        = false;
    m_bToggleLowpassStatus      = false;
    
    m_fGainValue                = 1.f;
}



// Motion Capture
- (void)motionDeviceUpdate:(CMDeviceMotion *)deviceMotion
{
    /*
        Initial (roll, pitch, yaw) = (0, 0, 0)
        roll =  spinning around the pole which is parallel to the long side of screen,
                0 at short side horizontal, ranges from -pi to pi, righty plus lefty minus
                a glitch happens when pi changes to -pi with slight spin
        pitch = spinning around the pole which is parallel to the short side of screen,
                0 at long side horizontal, ranges from -pi/2 to pi/2, think of phone as a
                fishing rod, then pointing to front is 0,
                pointing up is pi/2, pointing down is -pi/2,
                no glitch
        yaw =   spinning around the pole which is perpendicular to the surface of screen,
                ranges from -pi to pi, righty minus lefty plus
                a glitch happens when pi changes to -pi with slight spin
     */
    if (m_bToggleVibratoStatus)
    {
        backEndInterface->setParameter(1, 1, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2.f));
        backEndInterface->setParameter(1, 2, (deviceMotion.attitude.pitch + M_PI) / (M_PI));
    }
    if (m_bToggleDelayStatus)
    {
        backEndInterface->setParameter(2, 1, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2.f));
        backEndInterface->setParameter(2, 2, (deviceMotion.attitude.pitch + M_PI) / (M_PI));
    }
    if (m_bToggleLowpassStatus)
    {
        backEndInterface->setParameter(3, 1, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2.f));
        backEndInterface->setParameter(3, 2, (deviceMotion.attitude.pitch + M_PI) / (M_PI));
    }
    if (m_bTogglePitchShiftStatus)
    {
        backEndInterface->setParameter(4, 1, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2.f));
        backEndInterface->setParameter(4, 2, (deviceMotion.attitude.pitch + M_PI) / (M_PI));
    }
    
//    backEndInterface->setParameter(2, 1, 1 / (1 + expf(deviceMotion.userAcceleration.x)));
//    backEndInterface->setParameter(2, 2, 1 / (1 + expf(deviceMotion.userAcceleration.y)));
    
//    std::cout   << deviceMotion.attitude.roll << " "
//                << deviceMotion.attitude.pitch << " "
//                << deviceMotion.attitude.yaw << std::endl;
    
//    deviceMotion.attitude.roll;
//    deviceMotion.attitude.pitch;
//    deviceMotion.attitude.yaw;
//    
//    deviceMotion.userAcceleration.x;
//    deviceMotion.userAcceleration.y;
//    deviceMotion.userAcceleration.z;
//
//    deviceMotion.rotationRate.x;
//    deviceMotion.rotationRate.y;
//    deviceMotion.rotationRate.z;
//    
//    deviceMotion.attitude.quaternion.w;
//    deviceMotion.attitude.quaternion.x;
//    deviceMotion.attitude.quaternion.y;
//    deviceMotion.attitude.quaternion.z;
//    
//    deviceMotion.gravity.x;
//    deviceMotion.gravity.y;
//    deviceMotion.gravity.z;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toggleStartButtonClicked:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"test5.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    if (!m_bToggleStartStatus)
    {
        [sender setSelected:true];
        backEndInterface->toggleAudioButtonClicked(true);
        m_bToggleStartStatus    =   true;
    } else
    {
        [sender setSelected:false];
        backEndInterface->toggleAudioButtonClicked(false);
        m_bToggleStartStatus    =   false;
    }
}

- (IBAction)toggleVibratoButtonClicked:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"test5-1.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    if (!m_bToggleVibratoStatus)
    {
        [sender setSelected:true];
        backEndInterface->setEffectStatus(1);
        m_bToggleVibratoStatus = true;
    } else
    {
        [sender setSelected:false];
        backEndInterface->setEffectStatus(1);
        m_bToggleVibratoStatus = false;
    }
}
- (IBAction)togglePitchShiftButtonClicked:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"test5-2.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    if (!m_bTogglePitchShiftStatus)
    {
        [sender setSelected:true];
        backEndInterface->setEffectStatus(4);
        m_bTogglePitchShiftStatus = true;
    } else
    {
        [sender setSelected:false];
        backEndInterface->setEffectStatus(4);
        m_bTogglePitchShiftStatus = false;
    }
}
- (IBAction)toggleDelayButtonClicked:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"test5-3.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    if (!m_bToggleDelayStatus)
    {
        [sender setSelected:true];
        backEndInterface->setEffectStatus(2);
        m_bToggleDelayStatus = true;
    } else
    {
        [sender setSelected:false];
        backEndInterface->setEffectStatus(2);
        m_bToggleDelayStatus = false;
    }
}
- (IBAction)toggleLowpassButtonClicked:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"test5-4.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    if (!m_bToggleLowpassStatus)
    {
        [sender setSelected:true];
        backEndInterface->setEffectStatus(3);
        m_bToggleLowpassStatus = true;
    } else
    {
        [sender setSelected:false];
        backEndInterface->setEffectStatus(3);
        m_bToggleLowpassStatus = false;
    }
}


- (IBAction)gainSliderChanged:(UISlider *)sender
{
    m_fGainValue = [sender value];
    backEndInterface->setMicrophoneGain(m_fGainValue);
}

- (void)dealloc
{
    delete backEndInterface;
    
    [_toggleVibratoButton release];
    [_togglePitchShiftButton release];
    [_toggleDelayButton release];
    [_toggleLowpassButton release];
    [_toggleStartButton release];
    [_gainSlider release];
    [super dealloc];
}

@end