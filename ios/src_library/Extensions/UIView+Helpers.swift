
/// TODO:2023-03-24-01-14-26 - Move `UIView+Helpers` extension to
/// `react-native-utilities`
///
extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self;
    
    while parentResponder != nil {
      parentResponder = parentResponder!.next
      if let viewController = parentResponder as? UIViewController {
        return viewController;
      };
    };
    
    return nil
  };
  
  /// Remove all ancestor constraints that are affecting this view instance
  ///
  /// Note: 2023-03-24-00-39-51
  ///
  /// * From: https://stackoverflow.com/questions/24418884/remove-all-constraints-affecting-a-uiview
  ///
  /// * After it's done executing, your view remains where it was because it
  ///   creates autoresizing constraints.
  ///
  /// * When I don't do this the view usually disappears.
  ///
  /// * Additionally, it doesn't just remove constraints from it's superview,
  ///   but in addition, it also climbs the view hierarchy, and removes all the
  ///   constraints affecting the current view instance that came from an
  ///   ancestor view.
  ///
  public func removeAllAncestorConstraints() {
    var ancestorView = self.superview;
    
    // Climb the view hierarchy until there are no more parent views...
    while ancestorView != nil {
      for ancestorConstraint in ancestorView!.constraints {
        
        let constraintItems = [
          ancestorConstraint.firstItem,
          ancestorConstraint.secondItem
        ];
        
        constraintItems.forEach {
          guard ($0 as? UIView) === self else { return };
          ancestorView!.removeConstraint(ancestorConstraint);
        };
        
        ancestorView = ancestorView!.superview;
      };
    };
    
    self.removeConstraints(self.constraints);
    self.translatesAutoresizingMaskIntoConstraints = true
  };
};
