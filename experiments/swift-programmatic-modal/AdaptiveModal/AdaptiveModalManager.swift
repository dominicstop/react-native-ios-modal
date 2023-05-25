//
//  AdaptiveModalManager.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/24/23.
//

import UIKit



class AdaptiveModalManager {

 static func interpolate(
  inputValue : CGFloat,
  rangeInput : [CGFloat],
  rangeOutput: [CGFloat]
) -> CGFloat? {
  guard rangeInput.count == rangeOutput.count,
        rangeInput.count >= 2
  else { return nil };
  
  // A - Extrapolate Left
  if inputValue < rangeInput.first! {
     
    let rangeInputStart  = rangeInput.first!;
    let rangeOutputStart = rangeOutput.first!;
     
    let delta1 = rangeInputStart - inputValue;
    let percent = delta1 / rangeInputStart;
    
    // extrapolated "range output end"
    let rangeOutputEnd = rangeOutputStart - (rangeOutput[1] - rangeOutputStart);
    
    let interpolatedValue = RNIAnimator.EasingFunctions.lerp(
      valueStart: rangeOutputEnd,
      valueEnd: rangeOutputStart,
      percent: percent
    );
    
    let delta2 = interpolatedValue - rangeOutputEnd;
    return rangeOutputStart - delta2;
  };
  
  let (rangeStartIndex, rangeEndIndex): (Int, Int) = {
    let rangeInputEnumerated = rangeInput.enumerated();
    
    let match = rangeInputEnumerated.first {
      guard let nextValue = rangeInput[safeIndex: $0.offset + 1]
      else { return false };
      
      return inputValue >= $0.element && inputValue < nextValue;
    };
    
    // B - Interpolate Between
    if let match = match {
      let rangeStartIndex = match.offset;
      return (rangeStartIndex, rangeStartIndex + 1);
    };
      
    let lastIndex         = rangeInput.count - 1;
    let secondToLastIndex = rangeInput.count - 2;
    
    // C - Extrapolate Right
    return (secondToLastIndex, lastIndex);
  }();
  
  guard let rangeInputStart  = rangeInput [safeIndex: rangeStartIndex],
        let rangeInputEnd    = rangeInput [safeIndex: rangeEndIndex  ],
        let rangeOutputStart = rangeOutput[safeIndex: rangeStartIndex],
        let rangeOutputEnd   = rangeOutput[safeIndex: rangeEndIndex  ]
  else { return nil };
  
  let inputValueAdj    = inputValue    - rangeInputStart;
  let rangeInputEndAdj = rangeInputEnd - rangeInputStart;

  let progress = inputValueAdj / rangeInputEndAdj;
        
  return RNIAnimator.EasingFunctions.lerp(
    valueStart: rangeOutputStart,
    valueEnd  : rangeOutputEnd,
    percent   : progress
  );
};

  var targetRectProvider: () -> CGRect;
  var currentSizeProvider: () -> CGSize;
  
  var gestureOffset: CGFloat?;
  
  weak var modalView: UIView?;
  
  let snapPoints: [RNILayout] = [
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.1)
      )
    ),
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.3)
      )
    ),
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.7)
      )
    ),
  ];
  
  var currentSnapPointIndex = 1;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var computedSnapRects: [CGRect] {
    let targetSize  = self.targetRectProvider();
    let currentSize = self.currentSizeProvider();
    
    return self.snapPoints.map {
      $0.computeRect(
        withTargetRect: targetSize,
        currentSize: currentSize
      );
    };
  };
  
  var currentSnapPoint: RNILayout {
    return self.snapPoints[self.currentSnapPointIndex];
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
    nextSnapPoint: RNILayout,
    computedRect: CGRect
  ) {
    let targetRect = self.targetRectProvider();
    let currentSize = self.currentSizeProvider();
  
    let snapPointRects = self.snapPoints.map {
      $0.computeRect(
        withTargetRect: targetRect,
        currentSize: currentSize
      );
    };
    
    let diffY = snapPointRects.map {
      $0.origin.y - currentRect.origin.y
    };
    
    let closestSnapPoint = diffY.enumerated().first { item in
      diffY.allSatisfy {
        abs(item.element) <= abs($0)
      };
    };
    
    let closestSnapPointIndex = closestSnapPoint!.offset;
    let nextSnapPoint = self.snapPoints[closestSnapPointIndex];
    
    print("forRect", currentRect);
    print("withTargetRect", targetRect);
    print("snapPointRects", snapPointRects);
    print("diffY", diffY);
    print("closestSnapPoint", closestSnapPoint, "\n");
    
    return (
      nextSnapPointIndex: closestSnapPointIndex,
      nextSnapPoint: nextSnapPoint,
      computedRect: snapPointRects[closestSnapPointIndex]
    );
  };
  
  func interpolateModalRect(
    forGesturePointInTargetRect gesturePointInTargetRect: CGPoint,
    gesturePointRelativeToModal: CGPoint
  ) -> CGRect {
    guard let modalView = self.modalView else { return .zero };
    
    let targetRect = self.targetRectProvider();
    let modalRect = modalView.frame;
    
    let snapRects = self.computedSnapRects.reversed();
    
    let gestureOffset = self.gestureOffset ??
      gesturePointInTargetRect.y - modalRect.origin.y;
    
    if self.gestureOffset == nil {
      self.gestureOffset = gestureOffset;
    };
    
    let gestureInput = gesturePointInTargetRect.y - gestureOffset;
    let rangeInputGesture = snapRects.map { $0.minY };
    
    print(
        "gesturePoint: \(gesturePointInTargetRect)"
      + "\n" + " - gesturePointRelativeToModal: \(gesturePointRelativeToModal)"
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
  
  
  func _computeFrame(
    forGesturePointInTargetRect gesturePointInTargetRect: CGPoint,
    gesturePointRelativeToModal: CGPoint
  ) -> CGRect {
    guard let modalView = self.modalView else { return .zero };
    
    let targetRect  = self.targetRectProvider();
    // let currentSize = self.currentSizeProvider();
    
    let modalRect = modalView.frame;
    let offset = 0.0;
    
    let snapRects = self.computedSnapRects;
    
    func invertCoord(coord: CGFloat, targetCoordMax: CGFloat) -> CGFloat {
      let delta = targetCoordMax - coord;
      
      return delta < 0
        ? abs(delta) + targetCoordMax
        : delta;
    };
    
    let gestureInputInverted = invertCoord(
      coord: gesturePointInTargetRect.y,
      targetCoordMax: targetRect.maxY
    );
    
    let gestureInput = gesturePointInTargetRect.y + offset;
    
    let rangeInputGesture: [CGFloat] = {
      var range: [CGFloat] = [];
      
      // range.append(targetRect.minY);
      range += snapRects.reversed().map { $0.minY };
      // range.append(targetRect.maxY);
      
      return range;
    }();
    
    print(
        "gesturePoint: \(gesturePointInTargetRect)"
      + "\n" + " - gesturePointRelativeToModal: \(gesturePointRelativeToModal)"
      + "\n" + " - targetRect: \(targetRect)"
      + "\n" + " - gestureInput: \(gestureInput)"
      + "\n" + " - offset: \(offset)"
      + "\n" + " - snapRects: \(snapRects)"
      + "\n" + " - rangeInputGesture: \(rangeInputGesture)"
    );
    
    let nextHeight = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: {
        var range: [CGFloat] = [];
        
        // range.append(0);
        range += snapRects.reversed().map { $0.height };
        // range.append(targetRect.height);
        
        print(" - nextHeight rangeOutput: \(range)");
            
        return range;
      }()
    );
    
    print(" - nextHeight: \(nextHeight!)");
    
    let nextWidth = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: {
        var range: [CGFloat] = [];
        
        // range.append(targetRect.width);
        range += snapRects.map { $0.width };
        // range.append(targetRect.width);
        
        print(" - nextWidth rangeOutput: \(range)");
        
        return range;
      }()
    );
    
    print(" - nextWidth: \(nextWidth!)");
    
    let nextX = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: {
        var range: [CGFloat] = [];
        
        // range.append(targetRect.minX);
        range += snapRects.map { $0.minX };
        // range.append(targetRect.minX);
        
        print(" - nextX rangeOutput: \(range)");
        
        return range;
      }()
    );
    
    print(" - nextX: \(nextX!)");
    
    let _nextY = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: {
        var range: [CGFloat] = [];
        
        // range.append(targetRect.minY);
        range += snapRects.reversed().map { $0.minY };
        // range.append(targetRect.maxY);
        
        print(" - nextY rangeOutput: \(range)");
        
        return range;
      }()
    )!;
    
    let nextY = _nextY;// invertCoord(coord: _nextY, targetCoordMax: targetRect.maxY)
    
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
