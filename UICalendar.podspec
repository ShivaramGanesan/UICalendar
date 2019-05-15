Pod::Spec.new do |s|
  s.name             = 'UICalendar'
  s.version          = '2.1'
  s.summary          = 'Custom Calendar UI'
 
  s.description      = <<-DESC
MyPod
                       DESC
 
  s.homepage         = 'https://github.com/ShivaramGanesan/UICalendar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Shivaram Ganesan' => 'shivaramganesan0406@gmail.com' }
  s.source           = { :git => 'https://github.com/ShivaramGanesan/UICalendar.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '9.0'
  s.source_files = 'UICalendar/UICalendar.swift'
 
end
