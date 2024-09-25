//
//  RNIModalSheetViewShadowNode.h
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#if __cplusplus
#pragma once

#include <react-native-ios-utilities/RNIBaseViewShadowNode.h>
#include <react-native-ios-utilities/RNIBaseViewProps.h>
#include <react-native-ios-utilities/RNIBaseViewEventEmitter.h>

#include <react/renderer/components/RNIModalSpec/EventEmitters.h>
#include <react/renderer/components/RNIModalSpec/Props.h>

#include <react/renderer/components/view/ConcreteViewShadowNode.h>
#include <jsi/jsi.h>


namespace facebook::react {

JSI_EXPORT extern const char RNIModalSheetViewComponentName[] = "RNIModalSheetView";

class JSI_EXPORT RNIModalSheetViewShadowNode final : public RNIBaseViewShadowNode<
  RNIModalSheetViewComponentName,
  RNIBaseViewProps,
  RNIBaseViewEventEmitter
> {

public:
  using RNIBaseViewShadowNode::RNIBaseViewShadowNode;
  
  static RNIBaseViewState initialStateData(
      const Props::Shared&r          , // props
      const ShadowNodeFamily::Shared&, // family
      const ComponentDescriptor&       // componentDescriptor
  ) {
    return {};
  }
};

} // facebook::react
#endif
