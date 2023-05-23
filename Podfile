# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'First Pay' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for First Pay
  pod 'XLPagerTabStrip'
  pod 'IQKeyboardManager'
  pod 'KYDrawerController'
  pod 'Alamofire' , '~> 4.7.3'
  pod 'AlamofireObjectMapper'
  pod 'Toaster'#, '~> 2.3'
  pod 'SwiftyJSON'
  pod 'PinCodeTextField'
  pod 'SwiftKeychainWrapper', '~> 3.0'
  pod 'Siren', '~> 1.0.2'
#  pod 'SkyFloatingLabelTextField', '~> 3.0'
#  pod 'CardIO', '~> 5.4'
  pod 'iOSDropDown'
#  pod 'DLRadioButton', '~> 1.4'
#  pod 'Nuke', '~> 7.0'
  pod 'SwiftyRSA'
  pod 'SwiftWebVC'
  pod 'MHWebViewController', '~> 1.0'
  pod 'ALBusSeatView'
  pod 'GrowingTextView', '~> 0.7'
  pod 'libPhoneNumber-iOS'#, '~> 0.8'
  #pod 'UIImageViewAlignedSwift'
  pod 'CryptoSwift', '~>  1.6.0'
  pod 'RNCryptor', '~> 5.0.3'
  pod 'JHTAlertController'
   pod 'MBProgressHUD', '~> 1.2'
    pod 'SDWebImage', '~> 4.3'
  pod 'Kingfisher', '~> 4.0'
  pod 'GoogleMaps'
  pod 'GooglePlaces'

  
  #pod 'GoogleMLKit/BarcodeScanning'
  #pod 'GoogleMLKit/TextRecognition'
  pod 'SCLAlertView', '~> 0.8'
   #pod 'OneSignal', '~> 3.2'
   pod 'Toast-Swift', '~> 5.0'
  pod 'IQDropDownTextField'
  #pod 'iOSDropDown'
   pod 'PasswordTextField', '~> 1.2'
   pod 'OneSignalXCFramework', '>= 3.0.0', '< 4.0'
#  pod 'PinCodeInputView'
  pod 'OTPTextField', '~> 1.1'
  #pod 'CryptoSwift', '~> 1.6.0'
   pod 'SideMenu', '~> 5.0.0'
  # pod 'IQKeyboardManager'
# pod 'CardIO' #, '~> 5.4'

# Add the Firebase pod for Google Analytics
pod 'FirebaseAnalytics'

# For Analytics without IDFA collection capability, use this pod instead
# pod ‘Firebase/AnalyticsWithoutAdIdSupport’

# Add the pods for any other Firebase products you want to use in your app
# For example, to use Firebase Authentication and Cloud Firestore
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
end
target 'OneSignalNotificationServiceExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for OneSignalNotificationServiceExtension
  pod 'OneSignalXCFramework', '>= 3.0.0', '< 4.0'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
