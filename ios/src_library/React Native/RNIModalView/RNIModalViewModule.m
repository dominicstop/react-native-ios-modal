//
//  RNIModalViewModule.m
//  RNSwiftReviewer
//
//  Created by Dominic Go on 7/11/20.
//

#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"


@interface RCT_EXTERN_MODULE(RNIModalViewModule, RCTEventEmitter)

// MARK: - Standalone Functions
// ----------------------------

RCT_EXTERN_METHOD(dismissModalByID: (NSString)modalID
                  callback: (RCTResponseSenderBlock)callback
);

RCT_EXTERN_METHOD(dismissAllModals: (BOOL)animated
                  callback: (RCTResponseSenderBlock)callback
);

@end
