//
//  SharedLibraryViewController.m
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
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
    
    
    
    _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [testButton ];
}


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
    
    backEndInterface->setParameter(1, 1, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2.f));
    backEndInterface->setParameter(1, 2, (deviceMotion.attitude.pitch + M_PI) / (M_PI));
    
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
    if (!m_bToggleStartStatus)
    {
        [sender setSelected:true];
        [sender setBackgroundColor:[UIColor colorWithHue:0.8 saturation:1.0 brightness:0.6 alpha:1]];
        backEndInterface->toggleAudioButtonClicked(true);
        m_bToggleStartStatus    =   true;
    } else
    {
        [sender setSelected:false];
        [sender setBackgroundColor:[UIColor colorWithHue:0.33 saturation:1.0 brightness:0.6 alpha:1]];
        backEndInterface->toggleAudioButtonClicked(false);
        m_bToggleStartStatus    =   false;
    }
}

- (IBAction)toggleVibratoButtonClicked:(UIButton *)sender
{
    if (!m_bToggleVibratoStatus)
    {
        [sender setSelected:true];
        [sender setBackgroundColor:[UIColor colorWithHue:0.8 saturation:1.0 brightness:0.6 alpha:1]];
        backEndInterface->setEffectStatus(1);
        m_bToggleVibratoStatus = true;
    } else
    {
        [sender setSelected:false];
        [sender setBackgroundColor:[UIColor colorWithHue:0.5 saturation:1.0 brightness:0.6 alpha:1]];
        backEndInterface->setEffectStatus(1);
        m_bToggleVibratoStatus = false;
    }
}
- (IBAction)togglePitchShiftButtonClicked:(UIButton *)sender
{
    if (!m_bTogglePitchShiftStatus)
    {
        [sender setSelected:true];
        [sender setBackgroundColor:[UIColor colorWithHue:0.8 saturation:1.0 brightness:0.6 alpha:1]];
        m_bTogglePitchShiftStatus = true;
    } else
    {
        [sender setSelected:false];
        [sender setBackgroundColor:[UIColor colorWithHue:0.5 saturation:1.0 brightness:0.6 alpha:1]];
        m_bTogglePitchShiftStatus = false;
    }
}
- (IBAction)toggleDelayButtonClicked:(UIButton *)sender
{
    if (!m_bToggleDelayStatus)
    {
        [sender setSelected:true];
        [sender setBackgroundColor:[UIColor colorWithHue:0.8 saturation:1.0 brightness:0.6 alpha:1]];
        m_bToggleDelayStatus = true;
    } else
    {
        [sender setSelected:false];
        [sender setBackgroundColor:[UIColor colorWithHue:0.5 saturation:1.0 brightness:0.6 alpha:1]];
        m_bToggleDelayStatus = false;
    }
}
- (IBAction)toggleLowpassButtonClicked:(UIButton *)sender
{
    if (!m_bToggleLowpassStatus)
    {
        [sender setSelected:true];
        [sender setBackgroundColor:[UIColor colorWithHue:0.8 saturation:1.0 brightness:0.6 alpha:1]];
        m_bToggleLowpassStatus = true;
    } else
    {
        [sender setSelected:false];
        [sender setBackgroundColor:[UIColor colorWithHue:0.5 saturation:1.0 brightness:0.6 alpha:1]];
        m_bToggleLowpassStatus = false;
    }
}


- (void)dealloc
{
    delete backEndInterface;
    
    [_toggleVibratoButton release];
    [_togglePitchShiftButton release];
    [_toggleDelayButton release];
    [_toggleLowpassButton release];
    [_toggleStartButton release];
    [super dealloc];
}
@end
