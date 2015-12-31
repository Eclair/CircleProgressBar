Pod::Spec.new do |s|
  s.name         = "CircleProgressBar"
  s.version      = "0.3"
  s.summary      = "Circle ProgressBar control for iOS."
  s.description  = <<-DESC
                   Provides wide range of customization options.
                   Supports XCode 6 live rendering feature for on-the-fly customization.
                   Has ability to animate ProgressBar's progress chage.
                   DESC
  s.homepage     = "https://github.com/Eclair/CircleProgressBar"
  s.screenshots  = "https://raw.githubusercontent.com/Eclair/CircleProgressBar/master/Screenshots/ios-screen01.png", "https://raw.githubusercontent.com/Eclair/CircleProgressBar/master/Screenshots/ios-screen02.png"
  s.license      = 'MIT'
  s.author       = { "Andrey Cherkashin" => "cherkashin.andrey90@gmail.com" }
  s.source       = { :git => "https://github.com/Eclair/CircleProgressBar.git", :tag => "0.3" }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'CircleProgressBarDemo/CircleProgressBar/*'
  s.framework    = 'UIKit', 'QuartzCore'
end
