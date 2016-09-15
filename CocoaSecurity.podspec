#
#  Be sure to run `pod spec lint viking-pods.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name = "CocoaSecurity"
  s.version = "1.2.5"
  s.summary = "Encrypt/Decrypt: AES. Hash: MD5, SHA(SHA1, SHA224, SHA256, SHA384, SHA512). Encode/Decode: Base64, Hex."
  s.homepage = "https://github.com/kelp404/CocoaSecurity.git"
  s.license = "MIT"
  s.authors = { "Kelp": "kelp@phate.org" }
  s.source = { :git => "https://github.com/daneov/CocoaSecurity.git",
    :tag => "1.2.5"
  }
  s.dependency 'Base64nl', '~> 1.2'
  s.source_files = "CocoaSecurity/*.{h,m}"
  s.requires_arc = true
end