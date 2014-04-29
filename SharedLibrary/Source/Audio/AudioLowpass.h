//
//  AudioLowpass.h
//  HiveReturn
//
//  Created by Chih-Wei on 4/24/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __HiveReturn__AudioLowpass__
#define __HiveReturn__AudioLowpass__

#include <iostream>

#endif /* defined(__HiveReturn__AudioLowpass__) */

#include <cmath>


class CLPF
{
public:
    
    CLPF(int iNumChannel);
    ~CLPF();
    
    void setCutoff(float fCutoffFreq); //freq between 0~1
    void process(float **ppfInputBuffer, float **ppfOutputBuffer, int iBlockSize);
    void resetInstance();
    
private:
    float m_fCutoffFreq;
    float *m_pfPreviousValues;
    float *m_pfNewValues;
    int   m_iNumChannel;
    float m_fApy;
    float m_fCParam;
};
