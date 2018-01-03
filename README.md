## ANAChat iOS

The Powerful **ANAChat** allows you to integrate ANA chat bot to your app. Customise the UI according to your App Theme and you are all set. It is that simple!


## Getting started

ANAChat can be installed directly into your application via CocoaPods or by directly importing the source code files. Please note that ANAChat has a direct dependency on FCM that must be satisfied in order to build the components.

If you don't have an Xcode project yet, create one now.

#### CocoaPods Installation

We recommend using CocoaPods to install the libraries. You can install Cocoapods by following the [installation Instructions](https://guides.cocoapods.org/using/getting-started.html#getting-started).

1.  Now create a `Podfile` in the root of your project directory and add the following:

            $ cd your-project directory
            $ pod init

2. Add the pods that you want to install. You can include a Pod in your Podfile like this:

           use_frameworks!
           pod 'ANAChat'

3. Previous step downloads FCM files to the app and those should be configured with FCM. Please follow all the steps mentioned in below help document  except "Add the SDK" section. [FCM Documentation](https://firebase.google.com/docs/cloud-messaging/ios/client)

4. After FCM configuration modify below methods in `AppDelegate`:

Swift :
Import ANAChat modile in your  `AppDelegate`:

            import ANAChat
            
modify the method implementation of below methods:
                        
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                ......
                Messaging.messaging().delegate = self
                Messaging.messaging().shouldEstablishDirectChannel = true
                return true
            }
            
            func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
                AppLauncherManager.didReceiveFcmToken(withToken: fcmToken, baseAPIUrl: "#baseUrl", businessId: "businessID")
            }

            func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
                Messaging.messaging().apnsToken = deviceToken as Data
            }

            func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
                Messaging.messaging().appDidReceiveMessage(userInfo)
                AppLauncherManager.didReceiveRemoteNotification(userInfo)
                completionHandler(.newData)
            }

            public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage){
                AppLauncherManager.didReceiveRemoteNotification(remoteMessage.appData)
            }

Objective C:

Import ANAChat modile in your  `AppDelegate`:

            @import ANAChat;
            
modify the method implementation of below methods:

            - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
                ......
                [FIRMessaging messaging].delegate = self;
                [FIRMessaging messaging].shouldEstablishDirectChannel = YES;
            }
            
            - (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
                if (fcmToken.length > 0){
                    [AppLauncherManager didReceiveFcmTokenWithToken:fcmToken baseAPIUrl:@"#baseUrl" businessId:@"#businessID"];
                }
            }
            
            - (void)messaging:(nonnull FIRMessaging *)messaging didReceiveMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage{
                [AppLauncherManager didReceiveRemoteNotification:remoteMessage.appData];
            }
            
            - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
                [AppLauncherManager didReceiveRemoteNotification:userInfo];
                [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
            }
            
            - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
                [FIRMessaging messaging].APNSToken = deviceToken;
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


If you haven't added NSAppTransportSecurity till now, add the below permissions

            <key>NSAppTransportSecurity</key>
            <dict>
            <key>NSAllowsArbitraryLoads</key>
            <true/>
            <key>NSExceptionDomains</key>
            <dict>
            <key>example.com</key>
            <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
            </dict>
            </dict>
            </dict>
                


6.  You should import ANAChat and can use ANA Chat SDK from anywhere using the below code

Swift:


            let storyboard = UIStoryboard(name: "SDKMain", bundle: CommonUtility.getFrameworkBundle())
            let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            controller.businessId = "#businessID"
            controller.baseAPIUrl = "#baseUrl"
            controller.headerTitle = "Chatty"
            controller.baseThemeColor = UIColor.init(red: 0.549, green: 0.784, blue: 0.235, alpha: 1.0)
            controller.headerLogoImageName = "chatty"
            self.navigationController?.pushViewController(controller, animated: true)
            
Objective C :

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SDKMain" bundle:[CommonUtility getFrameworkBundle]];
            ChatViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
            controller.businessId = @"#businessID";
            controller.baseAPIUrl = @"#baseUrl";
            controller.headerTitle = @"Chatty";
            controller.baseThemeColor = [UIColor colorWithRed:0.549 green:0.784 blue:0.235 alpha:1.0];
            controller.headerLogoImageName = @"chatty";
            [self.navigationController pushViewController:controller animated:YES];
        
7. If you want to support location input type. You can include a  `GooglePlacePicker`  in your project with the [Google Places Documentation](https://developers.google.com/places/ios-api/start)(Follow the link upto Step 4). After Integrating the places to the application, Follow below steps to complete the Installation.

Swift :
Import `GooglePlacePicker`  in your module where you are initializing the SDK code

             import GooglePlacePicker

Connect to `ChatViewControllerDelegate` and the implement the below method:

            controller.delegate = self

copy the below code to your module:

            func presentLocationPopupOnViewController(_ vc: UIViewController){
                let config = GMSPlacePickerConfig(viewport: nil)
                let placePicker = GMSPlacePicker(config: config)
                
                placePicker.pickPlace(callback: {(place, error) -> Void in
                if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
                }
                if let latitude = place?.coordinate.latitude, let longitude = place?.coordinate.longitude{
                        let alertController: UIAlertController = UIAlertController(title: "Alert", message: "Do you want to share the selected location?", preferredStyle: .alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                        }
                        alertController.addAction(cancelAction)
                        
                        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                        
                        let locationInfo:[String: String] = ["latitude": String(latitude), "longitude" : String(longitude)]
                        // post a notification
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kLocationReceivedNotification"), object: nil, userInfo: locationInfo)
                        
                        }
                        alertController.addAction(okAction)
                        
                        vc.present(alertController, animated: true, completion: nil)
                    }
                })
            }


Objective C :
Import `GooglePlacePicker`  in your module where you are initializing the SDK code


            @import GooglePlacePicker;


Connect to `ChatViewControllerDelegate` and implement the below method:


            controller.delegate = self

copy the below code to your module:

            - (void)presentLocationPopupOnViewController:(UIViewController * _Nonnull)vc {
                GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
                GMSPlacePicker *placePicker = [[GMSPlacePicker alloc] initWithConfig:config];

                [placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
                    if (error != nil) {
                    NSLog(@"Pick Place error %@", [error localizedDescription]);
                    return;
                    }
                    UIAlertController * alert = [UIAlertController
                    alertControllerWithTitle:@"Alert"
                    message:@"Do you want to share the selected location?"
                    preferredStyle:UIAlertControllerStyleAlert];


                    UIAlertAction   *cancelAction = [UIAlertAction
                    actionWithTitle:@"Cancel"
                    style:UIAlertActionStyleCancel
                    handler:^(UIAlertAction * action) {

                    }];

                    UIAlertAction   *okAction = [UIAlertAction
                    actionWithTitle:@"Ok"
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {
                    if(place.coordinate.latitude && place.coordinate.longitude){
                        [[NSNotificationCenter defaultCenter] postNotificationName:
                        @"kLocationReceivedNotification" object:nil userInfo:
                        @{@"latitude" : [NSString stringWithFormat:@"%f",place.coordinate.latitude],
                        @"longitude" : [NSString stringWithFormat:@"%f",place.coordinate.longitude]}];
                        }
                    }];


                    [alert addAction:cancelAction];
                    [alert addAction:okAction];

                    [vc presentViewController:alert animated:YES completion:nil];
                }];
            }

#### Source Code Installation


If you wish to install ANAChat directly into your application from source, then clone the repository and add code and resources to your application:

1. Clone the respository and navigate to ANAChat-iOS-master/ANAChat/  and Drag and drop Classes folder into your project, instructing Xcode to copy items into your destination group's folder. If you are importing files into Objective C project, run the project after adding the files.

2. FCM configuration is required to use this SDK please check the documentation [here](https://firebase.google.com/docs/cloud-messaging/ios/client) to install and configure.

3. Follow the above steps from 4 to 8 to complete the installation.

    If you are importing into Objective C project, Replace import statement to "Your-Project-Name-Swift.h".
    If you are importing into Swift project, No import statement is required.

Note:

1.  Use the above codes with valid businessID and baseAPIUrl.
2.  Above code is for pushing the ChatViewController, you can use ChatViewController as per your requirement
3.  Configure the FCM server key on fcm-plugin to send the push notifications to the App. Use below steps to get FCM server key.
    1. On  FCM console
    2. Click the settings icon/cog wheel next to your project name at the top of the new Firebase Console
    3. Click Project settings
    4. Click on the Cloud Messaging tab
    5. The key is right under Server Key
4. Follow step 7 only if you want to support Input type location
                    

## License

ANAChat is available under the [GNU GPLv3 license](https://www.gnu.org/licenses/gpl-3.0.en.html).

