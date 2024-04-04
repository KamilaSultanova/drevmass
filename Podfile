# Uncomment the next line to define a global platform for your project
# platform :ios, '14.0'

target 'drevmass' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for drevmass
  pod 'SnapKit', '~> 5'
  pod 'SwiftLint', '~> 0'
  pod 'SDWebImage', '~> 5.0'
  pod 'KeychainSwift', '~> 20'
  pod 'Alamofire', '~> 5.0'
  pod 'SwiftyJSON', '~> 5'
	pod 'PanModal', '~> 1'
  pod 'youtube-ios-player-helper'
  pod 'SGSegmentedProgressBarLibrary'
  pod 'ReachabilitySwift' 

  target 'drevmassTests' do
    inherit! :search_paths
    # Pods for testing
  end

   target 'drevmassUITests' do
    # Pods for testing
  end

end

# Setup target iOS version for all pods after install
post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
  end
end
