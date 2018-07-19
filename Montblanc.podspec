Pod::Spec.new do |s|
  s.name         = "Montblanc"
  s.version      = "0.1.0"
  s.summary      = "Montblanc is a wrapper for CoreML Model Compiler."
  s.description  = <<-DESC
  Montblanc is a wrapper for CoreML Model Compiler. Montblanc written in Swift🐧 and support iOS & OSX.
                   DESC
  s.homepage     = "https://github.com/natmark/Montblanc"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Atsuya Sato" => "natmark0918@gmail.com" }
  s.osx.deployment_target = "10.13"
  s.ios.deployment_target = "11.4"
  s.source       = { :git => "https://github.com/natmark/Montblanc.git", :tag => "#{s.version}" }
  s.source_files  = "Montblanc/**/*.swift"
end
