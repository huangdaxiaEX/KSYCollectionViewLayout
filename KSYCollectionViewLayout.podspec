Pod::Spec.new do |s|
  s.name         = "KSYCollectionViewLayout"
  s.version      = “1.1”
  s.summary      = "UICollectionViewLayout."
  s.description  = "🚀 A waterfall flows collection view layout."
  s.homepage     = "https://github.com/huangdaxiaEX/KSYCollectionViewLayout/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "huangdaxia" => "527548875@qq.com" }
  s.source       = { :git => "https://github.com/huangdaxiaEX/KSYCollectionViewLayout.git", :tag => "#{s.version}" }
  s.source_files = "KSYCollectionViewLayout/Layout/*.{swift}"
  s.ios.deployment_target = '8.0'
end
