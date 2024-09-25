//
//  RNIModalSheetView.mm
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#import "RNIModalSheetView.h"

#import "react-native-ios-modal/Swift.h"
#import <react-native-ios-utilities/RNIBaseView.h>

#import <react-native-ios-utilities/RNIContentViewParentDelegate.h>


#import <react-native-ios-utilities/UIApplication+RNIHelpers.h>
#import <react-native-ios-utilities/RNIObjcUtils.h>

#if RCT_NEW_ARCH_ENABLED
#include "RNIModalSheetViewComponentDescriptor.h"

#include <react-native-ios-utilities/RNIBaseViewState.h>
#include <react-native-ios-utilities/RNIBaseViewProps.h>

#import <React/RCTConversions.h>
#import <React/RCTFabricComponentsPlugins.h>
#import <React/RCTRootComponentView.h>
#import <React/RCTSurfaceTouchHandler.h>

#include <react/renderer/core/ComponentDescriptor.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include <react/renderer/graphics/Float.h>
#include <react/renderer/core/graphicsConversions.h>

#import <react/renderer/components/RNIModalSpec/EventEmitters.h>
#import <react/renderer/components/RNIModalSpec/RCTComponentViewHelpers.h>
#else
#import <React/RCTTouchHandler.h>
#import <React/RCTInvalidating.h>
#endif

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
#endif


@interface RNIModalSheetView () <
  RNIContentViewParentDelegate,
#ifdef RCT_NEW_ARCH_ENABLED
  RCTRNIModalSheetViewViewProtocol
#else
  RCTInvalidating
#endif
> {
  // TBA
}
@end

@implementation RNIModalSheetView {
}

// MARK: - Init
// ------------

- (void)initCommon {
  [super initCommon];
}

// MARK: - RNIBaseView
// -------------------

+ (Class)viewDelegateClass
{
  return [RNIModalSheetViewDelegate class];
}

// MARK: - Fabric
// --------------

#if RCT_NEW_ARCH_ENABLED
+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<RNIModalSheetViewComponentDescriptor>();
}

Class<RCTComponentViewProtocol> RNIModalSheetViewCls(void)
{
  return RNIModalSheetView.class;
}
#else

// MARK: - Paper
// -------------

- (void)invalidate
{
  // to be impl.
}

#endif
@end



