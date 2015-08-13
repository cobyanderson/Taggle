  
  //
  //  AppDelegate.swift
  //  Template Project
  //
  //  Created by Benjamin Encz on 5/15/15.
  //  Copyright (c) 2015 Make School. All rights reserved.
  //
  
  import UIKit
  import Fabric
  import Crashlytics
  import Parse
  import Bond
  import FBSDKCoreKit
  import ParseUI
  
  
  @UIApplicationMain
  class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var parseLoginHelper: ParseLoginHelper!
    
    override init() {
        super.init()
        
        
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let user = user {
                
                let installation = PFInstallation.currentInstallation()
                installation["user"] = user
                installation.saveInBackground()
                
                // if login was successful, display the TabBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! UIViewController
                // 3
                
                self.window?.rootViewController?.presentViewController(tabBarController, animated: true, completion: nil)
            }
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics()])
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        //Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("jz88WGPNyj9LMDo0PxNxoniv5H74sU0Jps3HzxBQ",
            clientKey: "0z5vgeoN38CR49UgKtUplNXL1gKgGlm3KWmMZ0Uv")
        
        // [Optional] Track statistics around application opens.
        //PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
        let userNotificationTypes = (UIUserNotificationType.Alert |  UIUserNotificationType.Badge |  UIUserNotificationType.Sound);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Initialize Facebook
        // 1
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // check if we have logged in user
        // 2
        let user = PFUser.currentUser()
        
        let startViewController: UIViewController;
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if (user != nil) {
            // 3
            // if we have a user, set the TabBarController to be the initial View Controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! UINavigationController
            self.window?.rootViewController = startViewController
            
        } else {
            // 4
            presentLogInView()
            // Otherwise set the LoginViewController to be the first
            
        }
        
        // 5
        self.window?.makeKeyAndVisible()
        
        initializePromptList()
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        
        if let user = PFUser.currentUser() {
            installation["user"] = user
        }
        
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        
        let currentInstallation = PFInstallation.currentInstallation()
        if currentInstallation.badge != 0 {
            currentInstallation.badge = 0
            
            currentInstallation.saveEventually()
        }
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func presentLogInView() {
        //
        let loginViewController = PFLogInViewController()
        loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper
        
        var logoImage = UIImageView()
        logoImage.image = UIImage(named: "TaggleBig")
        logoImage.contentMode = UIViewContentMode.ScaleAspectFill
        var otherImage = UIImageView()
        otherImage.image = UIImage(named: "TaggleSurprisedSmall")
        otherImage.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        loginViewController.logInView?.logo = logoImage
        loginViewController.signUpController?.signUpView?.logo = otherImage
        loginViewController.logInView?.backgroundColor = UIColor(red: 48/255, green: 178/255, blue: 200/255, alpha: 1)
        loginViewController.logInView?.passwordForgottenButton?.backgroundColor = UIColor.whiteColor()
        loginViewController.logInView?.tintColor = UIColor(red: 48/255, green: 178/255, blue: 200/255, alpha: 1)
        loginViewController.signUpController?.signUpView?.backgroundColor =  UIColor(red: 48/255, green: 178/255, blue: 200/255, alpha: 1)
        
        self.window?.rootViewController = loginViewController
    }
  }
