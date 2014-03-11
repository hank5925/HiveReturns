//
//  SharedLibraryInterface.cpp
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "SharedLibraryInterface.h"


SharedLibraryInterface::SharedLibraryInterface()
{
    audioEngine     =   new AudioEngine();
}


SharedLibraryInterface::~SharedLibraryInterface()
{
    delete audioEngine;
}


void SharedLibraryInterface::toggleAudioButtonClicked(bool toggleStatus)
{
    if (toggleStatus)
    {
        audioEngine->startAudioStreaming();
    }
    
    else
    {
        audioEngine->stopAudioStreaming();
    }
}



void SharedLibraryInterface::setParameter(int effectID, int parameterID, float value)
{
    audioEngine->setEffectParam(effectID, parameterID, value);
    
}

void SharedLibraryInterface::setEffectStatus(int effectID)
{
    
}

