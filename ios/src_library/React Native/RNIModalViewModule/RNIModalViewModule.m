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
                  visibility: (BOOL)visibility
                  animated: (BOOL)visibility
                  // promise blocks -----------------------
                  resolve: (RCTPromiseResolveBlock *)resolve
                  reject : (RCTPromiseRejectBlock *)reject);

RCT_EXTERN_METHOD(dismissAllModals: (BOOL)animated
                  // promise blocks ------------------------
                  resolve: (RCTPromiseResolveBlock *)resolve
                  reject : (RCTPromiseRejectBlock *)reject);

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
