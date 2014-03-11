//
//  AudioVibrato.h
//  SharedLibrary
//
//  Created by Chih-Wei on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__AudioVibrato__
#define __SharedLibrary__AudioVibrato__

#include "ErrorDef.h"

class CLfo;
template <class T>
class CRingBuffer;

class CVibrato
{
public:
    /*! version number */
    enum Version_t
    {
        kMajor, //!< major version number
        kMinor, //!< minor version number
        kPatch, //!< patch version number
        
        kNumVersionInts
    };
    
    enum VibratoParam_t
    {
        kParamModWidthInS,
        kParamModFreqInHz,
        
        kNumVibratoParams
    };
    static const int getVersion (const Version_t eVersionIdx);
    static const char* getBuildDate ();
    
    static Error_t createInstance (CVibrato*& pCMyProject);
    static Error_t destroyInstance (CVibrato*& pCMyProject);
    
    Error_t initInstance (float fMaxModWidthInS, float fSampleRateInHz, int iNumChannels);
    Error_t resetInstance ();
    
    Error_t setParam (VibratoParam_t eParam, float fParamValue);
    float getParam (VibratoParam_t eParam) const;
    
    Error_t process (float **ppfInputBuffer, float **ppfOutputBuffer, int iNumberOfFrames);
    
protected:
    CVibrato ();
    virtual ~CVibrato ();
    
private:
    bool isInParamRange (VibratoParam_t eParam, float fValue);
    
    bool m_bIsInitialized;
    
    CLfo *m_pCLfo;
    CRingBuffer<float> **m_ppCRingBuff;
    
    float   m_fSampleRate;
    int     m_iNumChannels;
    float m_aafParamRange[kNumVibratoParams][2];
};
#endif /* defined(__SharedLibrary__AudioVibrato__) */
