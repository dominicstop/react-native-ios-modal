//
//  RNIModalViewComponentDescriptor.h
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#if __cplusplus
#pragma once

#include "RNIModalViewShadowNode.h"
#include "RNIBaseViewComponentDescriptor.h"

#include <react-native-ios-utilities/RNIBaseViewState.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>


namespace facebook::react {

class RNIModalViewComponentDescriptor final
  : public RNIBaseViewComponentDescriptor<RNIModalViewShadowNode> {
  
public:
  using RNIBaseViewComponentDescriptor::RNIBaseViewComponentDescriptor;
};

} // namespace facebook::react
#endif
