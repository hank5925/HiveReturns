//
//  SharedLibraryInterface.h
//  HiveReturn
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __HiveReturn__SharedLibraryInterface__
#define __HiveReturn__SharedLibraryInterface__

#include "AudioEngine.h"

class SharedLibraryInterface
{
public:
    
    SharedLibraryInterface();
    ~SharedLibraryInterface();
    
    void toggleAudioButtonClicked(bool toggleStatus);
    
    void setParameter(int effectID, int parameterID, float value);
    void setEffectStatus(int effectID);
    void setMicrophoneGain(float value);
private:
    
    AudioEngine*    audioEngine;
};

#endif /* defined(__HiveReturn__SharedLibraryInterface__) */
