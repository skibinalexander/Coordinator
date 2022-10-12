Pod::Spec.new do |s|
  s.name             = 'Coordinator'
  s.version          = '0.0.7'
  s.summary          = 'Implementation base Coordinator for router with modules on Swinject DI'
  s.description      = 'Implement pod Coordinator by use Coordinator logic routes'

  s.homepage         = 'https://github.com/skibinalexander/Coordinator.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Skibin Alexander' => 'skibinalexander@gmail.com' }
  s.source           = { :git => 'https://github.com/skibinalexander/Coordinator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = "5.0"
  s.source_files = 'Coordinator/Classes/**/*'
  s.dependency 'Swinject'
  s.dependency 'ModuleLauncher'
  s.dependency 'PanModal'

end
