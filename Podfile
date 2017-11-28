platform :ios, '9.0'

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end

target 'RedditPlus' do

  use_frameworks!

  pod 'AFNetworking', '~> 3.0'
  pod 'SDWebImage', '~> 4.0'
  pod 'ResponseDetective'

  target 'RedditPlusTests' do
    inherit! :search_paths

  end

end
