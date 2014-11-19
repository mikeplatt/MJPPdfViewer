Pod::Spec.new do |s|

    s.name              = 'MJPPdfViewer'
    s.version           = '0.0.1'
    s.summary           = 'iOS PDF Viewer'
    s.homepage          = 'https://github.com/mikeplatt/MJPPdfViewer'
    s.license           = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.author            = {
        'mikeplatt' => 'mikeplatt@inboox.com'
    }
    s.source            = {
        :git => 'https://github.com/mikeplatt/MJPPdfViewer.git',
        :tag => s.version.to_s
    }
    s.source_files      = 'Source/*.{m,h}'
    s.requires_arc      = true
	s.platform 			= :ios, "7.0"

end