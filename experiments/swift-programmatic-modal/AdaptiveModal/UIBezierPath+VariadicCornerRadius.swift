//
//  UIBezierPath+VariadicCornerRadius.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/28/23.
//

import UIKit

extension UIBezierPath {

  convenience init(
    shouldRoundRect rect: CGRect,
    topLeftRadius: CGFloat,
    topRightRadius: CGFloat,
    bottomLeftRadius: CGFloat,
    bottomRightRadius: CGFloat
  ) {
    self.init();

    let path = CGMutablePath()

    let topLeft     = rect.origin
    let topRight    = CGPoint(x: rect.maxX, y: rect.minY)
    let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
    let bottomLeft  = CGPoint(x: rect.minX, y: rect.maxY)

    if topLeftRadius != 0 {
      path.move(to: CGPoint(
        x: topLeft.x + topLeftRadius,
        y: topLeft.y
      ));
      
    } else {
      path.move(to: topLeft);
    }

    if topRightRadius != 0 {
      path.addLine(to: CGPoint(
        x: topRight.x - topRightRadius,
        y: topRight.y
      ));
      
      path.addArc(
        tangent1End: topRight,
        tangent2End: CGPoint(
          x: topRight.x,
          y: topRight.y + topRightRadius
        ),
        radius: topRightRadius
      );
        
    } else {
      path.addLine(to: topRight);
    };

    if bottomRightRadius != 0 {
      path.addLine(to: CGPoint(
        x: bottomRight.x,
        y: bottomRight.y - bottomRightRadius
      ));
      
      path.addArc(
        tangent1End: bottomRight,
        tangent2End: CGPoint(
          x: bottomRight.x - bottomRightRadius,
          y: bottomRight.y
        ),
        radius: bottomRightRadius
      );
      
    } else {
      path.addLine(to: bottomRight);
    };

    if bottomLeftRadius != 0 {
      path.addLine(to: CGPoint(
        x: bottomLeft.x + bottomLeftRadius,
        y: bottomLeft.y
      ));
      
      path.addArc(
        tangent1End: bottomLeft,
        tangent2End: CGPoint(
          x: bottomLeft.x,
          y: bottomLeft.y - bottomLeftRadius
        ),
        radius: bottomLeftRadius
      );
      
    } else {
      path.addLine(to: bottomLeft);
    };

    if topLeftRadius != 0 {
      path.addLine(to: CGPoint(
        x: topLeft.x,
        y: topLeft.y + topLeftRadius
      ));
      
      path.addArc(
        tangent1End: topLeft,
        tangent2End: CGPoint(
          x: topLeft.x + topLeftRadius,
          y: topLeft.y
        ),
        radius: topLeftRadius
      );
      
    } else {
      path.addLine(to: topLeft);
    };

    path.closeSubpath();
    cgPath = path;
  };
};

