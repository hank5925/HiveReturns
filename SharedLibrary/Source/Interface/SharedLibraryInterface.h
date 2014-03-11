//
//  SharedLibraryInterface.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__SharedLibraryInterface__
#define __SharedLibrary__SharedLibraryInterface__

#include "AudioEngine.h"

class SharedLibraryInterface
{
public:
    
    SharedLibraryInterface();
    ~SharedLibraryInterface();
    
    void toggleAudioButtonClicked(bool toggleStatus);
    
    void setParameter(int effectID, int parameterID, float value);
    
private:
    
    AudioEngine*    audioEngine;
};

#endif /* defined(__SharedLibrary__SharedLibraryInterface__) */
