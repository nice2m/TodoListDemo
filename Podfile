# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'TodoListDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TodoListDemo
  pod 'Hue'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'Alamofire', '~> 5.0.0-beta.5'
  pod 'SnapKit', '~> 5.0.0'
  pod 'CryptoSwift'
  pod 'KeychainAccess'
  pod 'PromiseKit/CorePromise', '~> 6.8'
  #pod 'Permission', :git => 'https://github.com/evdeve/Permission'

  
  def testing_pods
   # Pods for testing
   pod 'Quick'
   pod 'Nimble'
  end
  
  target 'TodoListDemoTests' do
    testing_pods
  end

  target 'TodoListDemoUITests' do
    testing_pods
  end
  
  target 'TodoListToday' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    testing_pods
  end

end
