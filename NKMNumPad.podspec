Pod::Spec.new do |s|
 s.name         = "NKMNumPad"
 s.version      = "0.0.3"
 s.summary = 'KeyPad as net.'
 s.platform = :ios, '7.0'
 s.homepage     = "https://github.com/nkmrh/NKMNumPad"
 s.license      = { :type => 'MIT', :file => 'LICENSE' } 
 s.author             = { "Hajime Nakamura" => "hajime-nakamura@cookpad.com" }
 s.source       = { :git => "https://github.com/nkmrh/NKMNumPad.git", :tag => "0.0.3" }
 s.source_files  = "NKMNumPad/**/*.{h,m}"
 s.resources = "NKMNumPad/**/*.png"
 s.frameworks = "OpenGLES", "GLkit", "CoreGraphics"
 s.requires_arc = true
end
