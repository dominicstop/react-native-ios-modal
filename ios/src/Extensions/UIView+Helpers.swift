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
  
  // From: https://stackoverflow.com/questions/24418884/remove-all-constraints-affecting-a-uiview
  // After it's done executing your view remains where it was because it creates autoresizing
  // constraints. When I don't do this the view usually disappears. Additionally, it doesn't just
  // remove constraints from superview but traversing all the way up as there may be constraints affecting it in ancestor views.
  public func removeAllConstraints() {
    var _superview = self.superview;
    
    while let superview = _superview {
      for constraint in superview.constraints {
        if let first = constraint.firstItem as? UIView, first == self {
          superview.removeConstraint(constraint)
        };

        if let second = constraint.secondItem as? UIView, second == self {
          superview.removeConstraint(constraint);
        };
      };
      
      _superview = superview.superview;
    };
    
    self.removeConstraints(self.constraints);
    self.translatesAutoresizingMaskIntoConstraints = true
  };
};
