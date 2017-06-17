source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘8.0’
use_frameworks!

target ‘YZMoney’ do

pod 'SDWebImage', '~> 3.7'
pod 'MSWeakTimer', '~> 1.1.0'
pod 'SDCycleScrollView', '~> 1.61'
pod 'ObjectiveSugar', '~> 1.1.0'
pod 'IQKeyboardManager', '~> 4.0.7'
pod 'JSONModel', '~> 1.7.0'
pod 'CYLTableViewPlaceHolder', '~> 1.0.8'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end

