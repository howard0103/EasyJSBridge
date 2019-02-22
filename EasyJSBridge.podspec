Pod::Spec.new do |s|
  s.name          = "EasyJSBridge"
  s.version       = "1.0.1"
  s.summary       = "iOS Native与H5交互神器，简单方便灵活，支持UIWebView和WKWebView for Swift"
  s.description   = "1 Native与H5双向通信 2 支持UIWebView和WKWebView 3 支持多个Scheme并存"
  s.homepage      = "https://github.com/howard0103/EasyJSBridge.git"
  s.license       = "MIT"
  s.author        = { "howard" => "344185723@qq.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/howard0103/EasyJSBridge.git", :tag => "#{s.version}" }
  s.source_files  = "Source"
  s.resources     = "Source/*.txt",
  s.exclude_files = "Classes/Exclude"
end
