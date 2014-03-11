//
//  ErrorDef.h
//  SharedLibrary
//
//  Created by Chih-Wei on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__ErrorDef__
#define __SharedLibrary__ErrorDef__

#if !defined(__ErrorDef_hdr__)
#define __ErrorDef_hdr__

enum Error_t
{
    kNoError,
    
    kFileOpenError,
    kFileAccessError,
    
    kFunctionInvalidArgsError,
    
    kNotInitializedError,
    
    kMemError,
    
    kUnknownError,
    
    kNumErrors
};
#endif // #if !defined(__ErrorDef_hdr__)





#endif /* defined(__SharedLibrary__ErrorDef__) */
