//
//  RNIModalSheetViewComponentDescriptor.h
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#if __cplusplus
#pragma once

#include "RNIModalSheetViewShadowNode.h"
#include "RNIBaseViewComponentDescriptor.h"

#include <react_native_ios_utilities/RNIBaseViewState.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>


namespace facebook::react {

class RNIModalSheetViewComponentDescriptor final : public RNIBaseViewComponentDescriptor<
  RNIModalSheetViewShadowNode,
  RNIModalSheetViewComponentName
> {
  
public:
  using RNIBaseViewComponentDescriptor::RNIBaseViewComponentDescriptor;
};

} // namespace facebook::react
#endif
