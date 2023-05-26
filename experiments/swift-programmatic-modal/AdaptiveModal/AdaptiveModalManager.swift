//
//  AdaptiveModalManager.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/24/23.
//

import UIKit

enum AdaptiveModalConfigTestPresets {
  case test01;
  
  var config: AdaptiveModalConfig {
    switch self {
      case .test01: return AdaptiveModalConfig(
        snapPoints:  [
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
                horizontalAlignment: .center,
                verticalAlignment: .bottom,
                width: RNIComputableValue(
                  mode: .stretch
                ),
              height: RNIComputableValue(
                mode: .percent(percentValue: 0.1)
              )
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNIComputableValue(
                mode: .stretch
              ),
              height: RNIComputableValue(
                mode: .percent(percentValue: 0.3)
              )
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNIComputableValue(
                mode: .stretch
              ),
              height: RNIComputableValue(
                mode: .percent(percentValue: 0.7)
              )
            )
          ),
        ],
        snapDirection: .vertical
      );
    };
  };
};

class AdaptiveModalManager {

  // MARK: -  Properties
  // -------------------
  
  let modalConfig: AdaptiveModalConfig =
    AdaptiveModalConfigTestPresets.test01.config;
    
  var currentSnapPointIndex = 1;

  var targetRectProvider: () -> CGRect;
  var currentSizeProvider: () -> CGSize;
  
  var gestureOffset: CGFloat?;
  weak var modalView: UIView?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  /// Defines which axis of the gesture point to use to drive the interpolation
  /// of the modal snap points
  ///
  var inputAxisKey: KeyPath<CGPoint, CGFloat> {
    switch self.modalConfig.snapDirection {
      case .vertical  : return \.y;
      case .horizontal: return \.x;
    };
  };
  
  /// The computed frames of the modal based on the snap points
  var computedSnapRects: [CGRect] {
    let targetSize  = self.targetRectProvider();
    let currentSize = self.currentSizeProvider();
    
    return self.modalConfig.snapPoints.map {
      $0.snapPoint.computeRect(
        withTargetRect: targetSize,
        currentSize: currentSize
      );
    };
  };
  
  var currentSnapPointConfig: AdaptiveModalSnapPointConfig {
    self.modalConfig.snapPoints[self.currentSnapPointIndex];
  };
  
  // MARK: - Init
  // ------------
  
  init(
    targetRectProvider: @escaping () -> CGRect,
    currentSizeProvider: @escaping () -> CGSize,
    modalView: UIView
  ){
    self.targetRectProvider = targetRectProvider;
    self.currentSizeProvider = currentSizeProvider;
    self.modalView = modalView;
  };
  
  // MARK: - Functions
  // -----------------

  func getNextSnapPoint(
    forRect currentRect: CGRect
  ) -> (
    nextSnapPointIndex: Int,
    nextSnapPoint: AdaptiveModalSnapPointConfig,
    computedRect: CGRect
  ) {
    return self.getClosestSnapPoint(
      forGestureCoord: currentRect.origin[keyPath: self.inputAxisKey]
    );
  };
  
  func getClosestSnapPoint(
    forGestureCoord: CGFloat
  ) -> (
    nextSnapPointIndex: Int,
    nextSnapPoint: AdaptiveModalSnapPointConfig,
    computedRect: CGRect
  ) {
    let snapRects = self.computedSnapRects;
    
    let diffY = snapRects.map {
      $0.origin[keyPath: self.inputAxisKey] - forGestureCoord;
    };
    
    let closestSnapPoint = diffY.enumerated().first { item in
      diffY.allSatisfy {
        abs(item.element) <= abs($0)
      };
    };
    
    let closestSnapPointIndex = closestSnapPoint!.offset;
    
    return (
      nextSnapPointIndex: closestSnapPoint!.offset,
      nextSnapPoint: self.modalConfig.snapPoints[closestSnapPointIndex],
      computedRect: snapRects[closestSnapPointIndex]
    );
  };
  
  func interpolateModalRect(
    forGesturePoint gesturePoint: CGPoint
  ) -> CGRect {
  
    guard let modalView = self.modalView else { return .zero };
    
    let targetRect = self.targetRectProvider();
    let modalRect = modalView.frame;
    
    let gestureCoord = gesturePoint[keyPath: self.inputAxisKey];
    let snapRects = self.computedSnapRects.reversed();
    
    let gestureOffset = self.gestureOffset ?? {
      let modalCoord = modalRect.origin[keyPath: self.inputAxisKey];
      return gestureCoord - modalCoord;
    }();
      
    if self.gestureOffset == nil {
      self.gestureOffset = gestureOffset;
    };
    
    let gestureInput = gestureCoord - gestureOffset;
    let rangeInputGesture = snapRects.map { $0.minY };
    
    print(
        "gesturePoint: \(gesturePoint)"
      + "\n" + " - targetRect: \(targetRect)"
      + "\n" + " - gestureInput: \(gestureInput)"
      + "\n" + " - offset: \(gestureOffset)"
      + "\n" + " - snapRects: \(snapRects)"
      + "\n" + " - rangeInputGesture: \(rangeInputGesture)"
    );
    
    let nextHeight = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: snapRects.map { $0.height }
    );
    
    print(" - nextHeight: \(nextHeight!)");
    
    let nextWidth = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: snapRects.map { $0.width }
    );
    
    print(" - nextWidth: \(nextWidth!)");
    
    let nextX = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: snapRects.map { $0.minX }
    );
    
    print(" - nextX: \(nextX!)");
    
    let nextY = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: snapRects.map { $0.minY }
    )!;

    print(" - nextY: \(nextY)");
    
    let nextRect = CGRect(
      x: nextX!,
      y: nextY,
      width: nextWidth!,
      height: nextHeight!
    );
    
    print(
               " - modalRect: \(modalRect)"
      + "\n" + " - nextRect: \(nextRect)"
      + "\n"
    );
    
    return nextRect;
  };
};
