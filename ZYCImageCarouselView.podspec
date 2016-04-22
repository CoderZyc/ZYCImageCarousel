Pod::Spec.new do |s|
s.name         = 'ZYCImageCarouselView'
s.version      = '1.0.0'
s.license      =  { :type => 'MIT', :file => 'LICENSE' }
s.authors      =  { 'CoderZyc' => '941077044@qq.com' }
s.summary      = 'About redisplay images.'
s.homepage     = 'https://github.com/CoderZyc/ZYCImageCarousel'

# Source Info
s.platform     =  :ios, '7.0'
s.source       =  { :git => 'https://github.com/CoderZyc/ZYCImageCarousel.git', :tag => s.version }
s.source_files = 'ZYCImageCarouselView/**/*.{h,m}'
s.resources    = 'ZYCImageCarouselView/ZYCImageCarouselView.bundle'
s.requires_arc = true
s.dependency 'SDWebImage', '~>3.7'
end
