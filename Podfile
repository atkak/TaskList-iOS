platform :ios, '9.0'

target 'TaskList-iOS' do
  use_frameworks!

  pod "Himotoki", "~> 2.1"
  pod 'BrightFutures'
  pod 'Alamofire', '~> 3.5'
  pod 'Eureka',
    git: 'git@github.com:xmartlabs/Eureka.git',
    branch: 'swift2.3'
  pod "PKHUD"
  pod 'RxSwift'
  pod 'RxCocoa'

  target 'TaskList-iOSTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
    pod 'Mockingjay'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end
