source 'https://cdn.cocoapods.org/'

use_frameworks!
#use_modular_headers!
deployment_target = '9.0'
platform :ios, deployment_target
inhibit_all_warnings!
install! 'cocoapods',
:disable_input_output_paths => true,
:generate_multiple_pod_projects => true,
:preserve_pod_file_structure => true,
:warn_for_unused_master_specs_repo => false
#:modular_headers => true

target 'NDLiveMsgRoom' do

  pod 'YYModel', '~> 1.0.4'
  pod 'YYImage', '~> 1.0.4'
  pod 'YYText', '~> 1.0.7'
  pod 'SDWebImage', '~> 5.11.1'
  pod 'Masonry', '~> 1.1.0'

end


post_install do |installer|
  installer.generated_projects.each do |project|
    project.build_configurations.each do |config|
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
    project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
      end
    end
  end
end
