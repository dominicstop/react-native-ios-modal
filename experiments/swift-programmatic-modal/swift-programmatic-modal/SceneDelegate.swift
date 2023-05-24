//
//  SceneDelegate.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 3/18/23.
//

import UIKit

class Helpers {
  
  static func getRootViewController(
    for window: UIWindow? = nil
  ) -> UIViewController? {
    
    if let window = window {
      return window.rootViewController;
    };
    
    #if swift(>=5.5)
    // Version: Swift 5.5 and newer - iOS 15 and newer
    let scenes = UIApplication.shared.connectedScenes;
    
    guard let windowScene = scenes.first as? UIWindowScene,
          let window = windowScene.windows.first
    else { return nil };
    
    return window.rootViewController;
    
    #elseif swift(>=5)
    // Version: Swift 5.4 and below - iOS 14.5 and below
    // Note: 'windows' was deprecated in iOS 15.0+
    guard let window = UIApplication.shared.windows.first else { return nil };
    return window.rootViewController;

    #elseif swift(>=4)
    // Version: Swift 4 and below - iOS 12.4 and below
    // Note: `keyWindow` was deprecated in iOS 13.0+
    guard let window = UIApplication.shared.keyWindow else { return nil };
    return window.rootViewController;
    
    #else
    // Version: Swift 3.1 and below - iOS 10.3 and below
    // Note: 'sharedApplication' has been renamed to 'shared'
    guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
          let window = appDelegate.window
    else { return nil };
    
    return window.rootViewController;
    #endif
  };
  
  static func getPresentedViewControllers() -> [UIViewController] {
    guard let rootVC = Self.getRootViewController() else {
      #if DEBUG
      print(
        "Helpers - getTopMostPresentedVC - Error: Could not get root "
        + "view controller"
      );
      #endif
      return [];
    };
    
    var presentedVCList: [UIViewController] = [rootVC];
    
    // climb the vc hierarchy to find the topmost presented vc
    while presentedVCList.last!.presentedViewController != nil {
      if let presentedVC = presentedVCList.last!.presentedViewController {
        presentedVCList.append(presentedVC);
      };
    };
    
    return presentedVCList;
  };
  
  static func getTopmostPresentedViewController() -> UIViewController? {
    return Self.getPresentedViewControllers().last;
  };
};


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?;
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // Use this method to optionally configure and attach the UIWindow `window`
    // to the provided UIWindowScene `scene`.
    //
    // If using a storyboard, the `window` property will automatically be
    // initialized and attached to the scene.
    //
    // This delegate does not imply the connecting scene or session are new
    // (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = (scene as? UIWindowScene) else { return };
    
    let window = UIWindow(windowScene: windowScene);
    self.window = window;
    
    let rootVC = TestRoutes.rootRouteKey.viewController;
    window.rootViewController = rootVC;
    window.makeKeyAndVisible();
    
    return;
    
    var delay = 1.0;
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
      let modalVC = UIViewController();
      modalVC.view = {
        let view = UIView();
        view.backgroundColor = .blue;
        
        return view;
      }();
      
      rootVC.present(modalVC, animated: true);
    };
    
    delay += 1;
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
      guard let topmostVC = Helpers.getTopmostPresentedViewController()
      else { return };
      
      let modalVC = UIViewController();
      modalVC.view = {
        let view = UIView();
        view.backgroundColor = .green;
        
        return view;
      }();
      
      // * once a modal has presented a vc
      topmostVC.present(modalVC, animated: true);
    };
    
    delay += 1;
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
      let listPresentedVC = Helpers.getPresentedViewControllers();
      
      // * 3 modals have been dismissed
      // * dismiss the first modal
      // * all the modals have been dismissed
      listPresentedVC[0].dismiss(animated: true);
    };
  };
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its
    // session is discarded.
    //
    // Release any resources associated with this scene that can be re-created
    // the next time the scene connects.
    //
    // The scene may re-connect later, as its session was not necessarily
    // discarded (see `application:didDiscardSceneSessions` instead).
  };
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active
    // state.
    //
    // Use this method to restart any tasks that were paused (or not yet
    // started) when the scene was inactive.
  };
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive
    // state.
    //
    // This may occur due to temporary interruptions (ex. an incoming phone
    // call).
  };
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  };
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    //
    // Use this method to save data, release shared resources, and store enough
    // scene-specific state information to restore the scene back to its
    // current state.
  };
};

