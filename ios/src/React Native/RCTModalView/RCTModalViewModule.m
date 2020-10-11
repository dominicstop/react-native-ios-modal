//
//  RCTModalViewModule.m
//  RNSwiftReviewer
//
//  Created by Dominic Go on 7/11/20.
//

#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(RCTModalViewModule, NSObject)

RCT_EXTERN_METHOD(dismissModalByID
          : (NSString)modalID
  callback: (RCTResponseSenderBlock)callback
);

RCT_EXTERN_METHOD(dismissAllModals
          : (bool)animated
  callback: (RCTResponseSenderBlock)callback
);

@end
