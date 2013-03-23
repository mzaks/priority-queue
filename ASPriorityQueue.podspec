#
Pod::Spec.new do |s|
  s.name         = "ASPriorityQueue"
  s.version      = "0.0.3"
  s.summary      = "A fast priority queue, implemented as a binary heap."
  s.homepage     = "https://github.com/arne-schroppe/priority-queue"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Arne Schroppe" => "arne.schroppe@gmx.de" }
  s.source       = { :git => "https://github.com/arne-schroppe/priority-queue.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files = 'ASPriorityQueue/'

  s.public_header_files = 'ASPriorityQueue'

end
