## ANAChat iOS Sdk!

The Powerful **ANAChat**  iOS SDK allows you to integrate ANA to your app. Customise the UI according to your App Theme and you are all set. It is that simple!


## Getting started

ANAChat can be installed directly into your application via CocoaPods or by directly importing the source code files. Please note that ANAChat has a direct dependency on FCM that must be satisfied in order to build the components.

If you don't have an Xcode project yet, create one now.

#### CocoaPods Installation

We recommend using CocoaPods to install the libraries. You can install Cocoapods by following the [installation Instructions](https://guides.cocoapods.org/using/getting-started.html#getting-started).

1.  Now create a `Podfile` in the root of your project directory and add the following:

            $ cd your-project directory
            $ pod init

2. Add the pods that you want to install. You can include a Pod in your Podfile like this:

            pod 'ANAChat'

3. Previous step downloads FCM files to the app and those should be configured with FCM. Please follow all the steps mentioned in below help document  except "Add the SDK" section.

[here](https://firebase.google.com/docs/cloud-messaging/ios/client)

4. After FCM configuration modify below classes in `AppDelegate`:

            func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
            AppLauncherManager.didReceiveFcmToken(fcmToken)
            }

            func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken as Data
            }

            func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
            Messaging.messaging().appDidReceiveMessage(userInfo)
            AppLauncherManager.didReceiveRemoteNotification(userInfo)completionHandler(.newData)
            }

            public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage){
            AppLauncherManager.didReceiveRemoteNotification(remoteMessage.appData)
            }


5. Add the below permissions to Target `info.plist` file by opening it as `Source Code`


            <key>NSMicrophoneUsageDescription</key>
            <string>This app would like to use microphone</string>
            <key>NSAppleMusicUsageDescription</key>
            <string>This app would like to use music</string>
            <key>NSCameraUsageDescription</key>
            <string>This app would like to use camera</string>
            <key>NSLocationAlwaysUsageDescription</key>
            <string>Will you allow this app to always know your location?</string>
            <key>NSLocationWhenInUseUsageDescription</key>
            <string>Do you allow this app to know your current location?</string>
            <key>NSPhotoLibraryUsageDescription</key>
            <string>This app would like to use photo</string>


6.  you can use SDK from anywhere using the below code

Swift:

            let storyboard = UIStoryboard(name: "SDKMain", bundle: CommonUtility.getFrameworkBundle())
            let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            controller.businessId = "#businessID"
            controller.headerTitle = "Chatty"
            controller.headerDescription = "(ANA Intelligence Agent)"
            controller.baseThemeColor = UIColor.init(hexString: "#8cc8wc")
            controller.headerLogoImageName = "chatty"
            self.navigationController?.pushViewController(controller, animated: true)
            
Objective C :

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SDKMain" bundle:[CommonUtility getFrameworkBundle]];
            ChatViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
            [self.navigationController pushViewController:controller animated:YES];
        


#### Source Code Installation


If you wish to install ANAChat directly into your application from source, then clone the repository and add code and resources to your application:

1. Drag and drop the files from the Code and Resources directories onto your project, instructing Xcode to copy items into your destination group's folder.

2. FCM configuration is required to use this SDK please check the documentation [here](https://firebase.google.com/docs/cloud-messaging/ios/client) to install and configure.

follow the above steps from 4 to 7  to complete the installation


## Author

RakeshTatekonda609, rakesh.tatekonda@nowfloats.com

## License

ANAChat is available under the GNU-GPL V3 license. See the LICENSE file for more info.

