//
//  HiveReturnViewController.m
//  HiveReturn
//
//  Created by Ying-Shu Kuo on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import "HiveReturnViewController.h"

#define SAMPLE_RATE 0.01

@interface HiveReturnViewController ()

@end

@implementation HiveReturnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Motion Manager Initialization
    self.motionManager = [[CMMotionManager alloc] init];
    
    if (!self.motionManager.isDeviceMotionAvailable)
    {
        NSLog(@"Something wrong here...");
        NSLog(@"viewDidLoad <-- HiveReturnViewController");
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
    
    m_bAccelerometerTriggerStatus = false;
    m_bAccelerometerTriggerPreviousStatus = false;
    m_iAccelerometerTriggerCounter = 0;
    
    m_bLeftFrontTriggerStatus = false;
    m_bLeftFrontTriggerPreviousStatus = false;
    m_iLeftFrontTriggerCounter = 0;
    
    m_bRightFrontTriggerStatus = false;
    m_bRightFrontTriggerPreviousStatus = false;
    m_iRightFrontTriggerCounter = 0;
    
    m_bLeftBackTriggerStatus = false;
    m_bLeftBackTriggerPreviousStatus = false;
    m_iLeftBackTriggerCounter = 0;
    
    m_bRightBackTriggerStatus = false;
    m_bRightBackTriggerPreviousStatus = false;
    m_iRightBackTriggerCounter = 0;
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
        backEndInterface->setParameter(1, 0, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2));
        backEndInterface->setParameter(1, 1, (deviceMotion.attitude.pitch + M_PI / 2) / (M_PI));
    }
    if (m_bToggleDelayStatus)
    {
        backEndInterface->setParameter(2, 0, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2));
        backEndInterface->setParameter(2, 1, (deviceMotion.attitude.pitch + M_PI / 2) / (M_PI));
    }
    if (m_bToggleLowpassStatus)
    {
        backEndInterface->setParameter(3, 0, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2));
        backEndInterface->setParameter(3, 1, (deviceMotion.attitude.pitch + M_PI / 2) / (M_PI));
    }
    if (m_bTogglePitchShiftStatus)
    {
        backEndInterface->setParameter(4, 0, (deviceMotion.attitude.roll + M_PI) / (M_PI * 2));
        backEndInterface->setParameter(4, 1, (deviceMotion.attitude.pitch + M_PI / 2) / (M_PI));
    }
    
//    backEndInterface->setParameter(2, 1, 1 / (1 + expf(deviceMotion.userAcceleration.x)));
//    backEndInterface->setParameter(2, 2, 1 / (1 + expf(deviceMotion.userAcceleration.y)));

    

    //Accelerometer Trigger Status Update
    double threshold = 0.6f;
    int cool_down = 50;
    
    if (deviceMotion.userAcceleration.x > threshold && deviceMotion.userAcceleration.y < -threshold) {
        if (!(m_bLeftFrontTriggerStatus || m_bRightFrontTriggerStatus || m_bLeftBackTriggerStatus || m_bRightBackTriggerStatus || m_bAccelerometerTriggerStatus)) {
            m_bLeftFrontTriggerStatus = true;
            m_iLeftFrontTriggerCounter = 0;
        }
    }
    if (m_bLeftFrontTriggerStatus == true) {
        m_iLeftFrontTriggerCounter += 1;
        if (m_iLeftFrontTriggerCounter >= cool_down) {
            m_iLeftFrontTriggerCounter = 0;
            m_bLeftFrontTriggerStatus = false;
        }
    }
    
    if (deviceMotion.userAcceleration.x < -threshold && deviceMotion.userAcceleration.y < -threshold) {
        if (!(m_bLeftFrontTriggerStatus || m_bRightFrontTriggerStatus || m_bLeftBackTriggerStatus || m_bRightBackTriggerStatus || m_bAccelerometerTriggerStatus)) {
            m_bRightFrontTriggerStatus = true;
            m_iRightFrontTriggerCounter = 0;
        }
    }
    if (m_bRightFrontTriggerStatus == true) {
        m_iRightFrontTriggerCounter += 1;
        if (m_iRightFrontTriggerCounter >= cool_down) {
            m_iRightFrontTriggerCounter = 0;
            m_bRightFrontTriggerStatus = false;
        }
    }
    
    if (deviceMotion.userAcceleration.x > threshold && deviceMotion.userAcceleration.y > threshold) {
        if (!(m_bLeftFrontTriggerStatus || m_bRightFrontTriggerStatus || m_bLeftBackTriggerStatus || m_bRightBackTriggerStatus || m_bAccelerometerTriggerStatus)) {
            m_bLeftBackTriggerStatus = true;
            m_iLeftBackTriggerCounter = 0;
        }
    }
    if (m_bLeftBackTriggerStatus == true) {
        m_iLeftBackTriggerCounter += 1;
        if (m_iLeftBackTriggerCounter >= cool_down) {
            m_iLeftBackTriggerCounter = 0;
            m_bLeftBackTriggerStatus = false;
        }
    }
    
    if (deviceMotion.userAcceleration.x < -threshold && deviceMotion.userAcceleration.y > threshold) {
        if (!(m_bLeftFrontTriggerStatus || m_bRightFrontTriggerStatus || m_bLeftBackTriggerStatus || m_bRightBackTriggerStatus || m_bAccelerometerTriggerStatus)) {
            m_bRightBackTriggerStatus = true;
            m_iRightBackTriggerCounter = 0;
        }
    }
    if (m_bRightBackTriggerStatus == true) {
        m_iRightBackTriggerCounter += 1;
        if (m_iRightBackTriggerCounter >= cool_down) {
            m_iRightBackTriggerCounter = 0;
            m_bRightBackTriggerStatus = false;
        }
    }
    
    if (fabs(deviceMotion.userAcceleration.z) > 2) {
        if (!(m_bLeftFrontTriggerStatus || m_bRightFrontTriggerStatus || m_bLeftBackTriggerStatus || m_bRightBackTriggerStatus || m_bAccelerometerTriggerStatus)) {
            m_bAccelerometerTriggerStatus = true;
            m_iAccelerometerTriggerCounter = 0;
        }
    }
    if (m_bAccelerometerTriggerStatus == true) {
        m_iAccelerometerTriggerCounter += 1;
        if (m_iAccelerometerTriggerCounter >= cool_down) {
            m_iAccelerometerTriggerCounter = 0;
            m_bAccelerometerTriggerStatus = false;
        }
    }
    
    if (m_bAccelerometerTriggerStatus) {
        [self toggleStartButtonClicked:nil];
    }
    if (m_bLeftFrontTriggerStatus) {
        [self toggleVibratoButtonClicked:nil];
    }
    if (m_bRightFrontTriggerStatus) {
        [self togglePitchShiftButtonClicked:nil];
    }
    if (m_bLeftBackTriggerStatus) {
        [self toggleDelayButtonClicked:nil];
    }
    if (m_bRightBackTriggerStatus) {
        [self toggleLowpassButtonClicked:nil];
    }
    

    
    m_bAccelerometerTriggerPreviousStatus = m_bAccelerometerTriggerStatus;
    m_bLeftFrontTriggerPreviousStatus = m_bLeftFrontTriggerStatus;
    m_bRightFrontTriggerPreviousStatus = m_bRightFrontTriggerStatus;
    m_bLeftBackTriggerPreviousStatus = m_bLeftBackTriggerStatus;
    m_bRightBackTriggerPreviousStatus = m_bRightBackTriggerStatus;
    
    
    
    /*
     
        Corpse of YAW Selector
     
        Yaw is not as robust as we thought. The critical issue is the "Drifting Yaw".
        Which means the Yaw value changes when intense motion happened. Precisely, origin direction of yaw drifted clockwise.
     
    */
//    std::cout << deviceMotion.attitude.roll << " " << deviceMotion.attitude.pitch << " " << deviceMotion.attitude.yaw;
//    if (deviceMotion.attitude.yaw >= M_PI / 10 && deviceMotion.attitude.yaw < M_PI * 3 / 10) {
//        std::cout << " ONE";
//    } else if (deviceMotion.attitude.yaw >= M_PI * 3 / 10 && deviceMotion.attitude.yaw < M_PI * 5 / 10) {
//        std::cout << "THREE";
//    } else if (deviceMotion.attitude.yaw >= -M_PI * 3 / 10 && deviceMotion.attitude.yaw < -M_PI / 10) {
//        std::cout << " TWO";
//    } else if (deviceMotion.attitude.yaw >= -M_PI * 5 / 10 && deviceMotion.attitude.yaw < -M_PI * 3 / 10) {
//        std::cout << " FOUR";
//    } else if (deviceMotion.attitude.yaw >= -M_PI / 10 && deviceMotion.attitude.yaw < M_PI / 10) {
//        std::cout << " SSSSSSTART!!!";
//    }
    
//    if (m_bAccelerometerTriggerPreviousStatus == false && m_bAccelerometerTriggerStatus == true){
////        if (deviceMotion.attitude.yaw + M_PI < M_PI_2) {
////            std::cout << " THREE";
////            [self toggleLowpassButtonClicked:nil];
////        }
//        if (deviceMotion.attitude.yaw >= M_PI / 10 && deviceMotion.attitude.yaw < M_PI * 3 / 10) {
////            std::cout << " ONE";
//            [self toggleVibratoButtonClicked:nil];
//        } else if (deviceMotion.attitude.yaw >= M_PI * 3 / 10 && deviceMotion.attitude.yaw < M_PI * 5 / 10) {
////            std::cout << "THREE";
//            [self toggleDelayButtonClicked:nil];
//        } else if (deviceMotion.attitude.yaw >= -M_PI * 3 / 10 && deviceMotion.attitude.yaw < -M_PI / 10) {
////            std::cout << " TWO";
//            [self togglePitchShiftButtonClicked:nil];
//        } else if (deviceMotion.attitude.yaw >= -M_PI * 5 / 10 && deviceMotion.attitude.yaw < -M_PI * 3 / 10) {
////            std::cout << " FOUR";
//            [self toggleLowpassButtonClicked:nil];
//        } else if (deviceMotion.attitude.yaw >= -M_PI / 10 && deviceMotion.attitude.yaw < M_PI / 10) {
////            std::cout << " SSSSSSTART!!!";
//            [self toggleStartButtonClicked:nil];
//        }
//    }
////    std::cout << std::endl;
    
    
    
    

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