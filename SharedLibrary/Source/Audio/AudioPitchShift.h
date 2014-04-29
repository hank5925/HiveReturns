//
//  AudioPitchShift.h
//  HiveReturn
//
//  Created by Chih-Wei on 4/26/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __HiveReturn__AudioPitchShift__
#define __HiveReturn__AudioPitchShift__

#include <iostream>

#endif /* defined(__HiveReturn__AudioPitchShift__) */

#define MAX_FRAMES 200000

class CPitchShift
{
public:
    
    CPitchShift(int iNumChannel);
    ~CPitchShift();
    
    void setAlpha(float fNewAlpha);
    void process(float **ppfInputBuffer, float **ppfOutputBuffer, int iBlockSize);
    void resetInstance();
    
    
private:
    int   m_iN1;
    int   m_iN2;
    float m_fAlpha;
    float m_fFactor;
    int   m_iNumChannel;
    
    
    float **ppfExtendedFrames;
};