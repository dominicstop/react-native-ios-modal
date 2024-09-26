//
//  ViewControllerLifecycleNotifier.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit
import DGSwiftUtilities


open class ViewControllerLifecycleNotifier: UIViewController {

  #if DEBUG
  public static var shouldLog = true;
  #endif

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
    if Self.shouldLog {
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
    if Self.shouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
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
    if Self.shouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
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
    if Self.shouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
        "\n"
      );
    };
    #endif
  };
  
  public override func viewWillDisappear(_ animated: Bool) {
    self.lifecycleEventDelegates.invoke {
      $0.notifyOnViewWillDisappear(sender: self, isAnimated: animated);
    };
    
    #if DEBUG
    if Self.shouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
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
    if Self.shouldLog {
      print(
        "ViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - animated:", animated,
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
    if Self.shouldLog {
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
    if Self.shouldLog {
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
};
