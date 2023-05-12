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

RCT_EXTERN_METHOD(setModalVisibilityByID: (NSString)modalID
                  // promise blocks -----------------------
                  resolve: (RCTPromiseResolveBlock *)resolve
                  reject : (RCTPromiseRejectBlock *)reject);

RCT_EXTERN_METHOD(dismissAllModals: (BOOL)animated
                  callback: (RCTResponseSenderBlock)callback
);

// MARK: - View-Related Functions
// ------------------------------

RCT_EXTERN_METHOD(setModalVisibility: (nonnull NSNumber)node
                  visibility: (BOOL)visibility
                  // promise blocks -----------------------
                  resolve: (RCTPromiseResolveBlock *)resolve
                  reject : (RCTPromiseRejectBlock *)reject);

RCT_EXTERN_METHOD(requestModalInfo: (nonnull NSNumber) node
                  // promise blocks -----------------------
                  resolve: (RCTPromiseResolveBlock *)resolve
                  reject : (RCTPromiseRejectBlock *)reject);

@end
