# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Forecast' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Forecast
  pod 'Alamofire', '~> 4.7'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SwiftEventBus', :tag => '3.0.0', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'

  # pod 'NVActivityIndicatorView'

  pod 'RealmSwift'

  # Firebase Pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'

  target 'ForecastTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ForecastUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
