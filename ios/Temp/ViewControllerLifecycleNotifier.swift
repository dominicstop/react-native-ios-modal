//
//  ViewControllerLifecycleNotifier.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit
import DGSwiftUtilities


open class ViewControllerLifecycleNotifier: UIViewController {

  private(set) public var lifecycleEventDelegates:
    MulticastDelegate<ViewControllerLifecycleNotifiable> = .init();
    
  // MARK: - Init
  // ------------
  
  public convenience init() {
    self.init(nibName: nil, bundle: nil);
  };
  
  // MARK: - View Controller Lifecycle
  // ---------------------------------

  public override func viewDidLoad() {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewDidLoad(sender: self);
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n"
      );
    };
    #endif
  };

  public override func viewWillAppear(_ animated: Bool) {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewWillAppear(sender: self, isAnimated: animated);
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
        "\n - isBeingPresented:", self.isBeingPresented,
        "\n"
      );
    };
    #endif
  };
  
  public override func viewIsAppearing(_ animated: Bool) {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewIsAppearing(sender: self, isAnimated: animated);
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
        "\n - isBeingPresented:", self.isBeingPresented,
        "\n"
      );
    };
    #endif
  };
  
  public override func viewDidAppear(_ animated: Bool) {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewDidAppear(sender: self, isAnimated: animated);
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
        "\n - isBeingPresented:", self.isPresentedAsModal,
        "\n"
      );
    };
    
    self._debugLogViewControllerMetricsIfNeeded();
    #endif
  };
  
  public override func viewWillDisappear(_ animated: Bool) {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewWillDisappear(sender: self, isAnimated: animated);
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
        "\n - isBeingDismissed:", self.isBeingDismissed,
        "\n"
      );
    };
    #endif
  };
  
  public override func viewDidDisappear(_ animated: Bool) {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewDidDisappear(sender: self, isAnimated: animated);
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
        "\n - isBeingDismissed:", self.isBeingDismissed,
        "\n"
      );
    };
    #endif
  };

  public override func viewWillLayoutSubviews() {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewWillLayoutSubviews(sender: self);
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n"
      );
    };
    #endif
  };
  
  public override func viewDidLayoutSubviews() {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewWillLayoutSubviews(sender: self);
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n"
      );
    };
    #endif
  };
  
  // MARK: - Methods
  // ---------------
  
  public func addEventDelegate(_ delegate: AnyObject){
    guard let delegate = delegate as? ViewControllerLifecycleNotifiable else {
      return;
    };
    
    self.lifecycleEventDelegates.add(delegate);
  };
  
  // MARK: - Debug-Related
  // ---------------------
  
  #if DEBUG
  public static var _debugShouldLog = true;
  
  private var _debugDidAutoLogViewControllerMetrics = false;

  func debugLogViewControllerMetrics(invoker: String = #function){
    var debugMessage =
        "ViewControllerLifecycleNotifier.logViewControllerMetrics"
      + "\n - invoker: \(invoker)"
      + "\n - instance: \(Unmanaged.passUnretained(self).toOpaque())"
      + "\n - className: \(self.className)"
      + "\n - isBeingDismissed: \(self.isBeingDismissed)"
      + "\n - isBeingPresented: \(self.isBeingPresented)"
      + "\n - isPresentedAsModal: \(self.isPresentedAsModal)"
      + "\n - modalLevel: \(self.modalLevel?.description ?? "N/A")"
      + "\n - topmostModalLevel: \(self.topmostModalLevel?.description ?? "N/A")";
      
    let allPresentedVC = self.recursivelyGetAllPresentedViewControllers;
    
    debugMessage += "\n - allPresentedVC.count: \(allPresentedVC.count)";
      
    debugMessage += allPresentedVC.enumerated().reduce("") {
      $0 + "\n -"
         + "\n - presentedVC \($1.offset + 1) of \(allPresentedVC.count)"
         + "\n - instance: \(Unmanaged.passUnretained($1.element).toOpaque())"
         + "\n - className: \($1.element.className)"
         + "\n - isPresentedAsModal: \($1.element.isPresentedAsModal)"
         + "\n - isTopMostModal: \($1.element.isTopMostModal)"
         + "\n - modalLevel: \($1.element.modalLevel?.description ?? "N/A")"
         + "\n - isUsingSheetPresentationController: \($1.element.isUsingSheetPresentationController)"
         + "\n - closestSheetPanGesture: \($1.element.closestSheetPanGesture?.debugDescription ?? "N/A")";
    };
    
    print(debugMessage);
  };
  
  private func _debugLogViewControllerMetricsIfNeeded(invoker: String = #function){
    guard !self._debugDidAutoLogViewControllerMetrics else {
      return;
    };
    
    self._debugDidAutoLogViewControllerMetrics = true;
    self.debugLogViewControllerMetrics(invoker: invoker);
  };
  #endif
};
