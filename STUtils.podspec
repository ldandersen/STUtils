Pod::Spec.new do |s|
  s.name         = "STUtils"
  s.version      = "0.0.1"
  s.summary      = "Various useful Objective-C code."
  s.homepage     = "https://github.com/ldandersen/STUtils.git"
  s.license      = "MIT"
  s.authors      = { 'Buzz Andersen' => 'buzz@scifihifi.com' }

  s.source       = { :git => "https://github.com/ldandersen/STUtils.git", :branch => "independentKeychain" }
  s.requires_arc = false
  
  s.subspec 'Additions' do |ios|  
    ios.source_files = "iOS/**/*"
  end

  s.subspec 'Security' do |security|
    security.source_files = "Security"
    security.frameworks = "Security"
  end
end
