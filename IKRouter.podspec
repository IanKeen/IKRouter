Pod::Spec.new do |spec|
  spec.name         = 'IKRouter'
  spec.version      = '1.0.4'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/iankeen/'
  spec.authors      = { 'Ian Keen' => 'iankeen82@gmail.com' }
  spec.summary      = 'URL Router that can automatically produce a deep navigation stack for you'
  spec.source       = { :git => 'https://github.com/iankeen/ikrouter.git', :tag => spec.version.to_s }

  spec.source_files = 'IKRouter/**/**.{swift}'
  
  spec.requires_arc = true
  spec.platform     = :ios
  spec.ios.deployment_target = "8.0"
end
