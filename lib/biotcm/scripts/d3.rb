# encoding: UTF-8
require 'fileutils'

# For data visualization
class BioTCM::Scripts::D3 < BioTCM::Scripts::Script
  # Version of D3
  VERSION = '0.1.0'
  # Supported chart type
  CHART_TYPES = [:bar]

  # General method to visualize data
  # @param type [Symbol] any type in {CHART_TYPES}
  # @param opts [Hash] options to create a chart
  # @option opts :title [String]
  # @return [self]
  # @raise ArgumentError if unsupported chart type given
  def run(type, opts={})
    if CHART_TYPES.include?(type)
      send(type, opts)
    else
      raise ArgumentError, 'Unsupported chart type'
    end
  end
  # Show demos
  # @return [self]
  def demo(type)
    if CHART_TYPES.include?(type)
      send("demo_#{type}")
    else
      raise ArgumentError, 'Unsupported chart type'
    end
  end
  # Show the page
  # @return [self]
  def view
    link = path_to 'index.html'
    if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
      system "start #{link}"
    elsif RbConfig::CONFIG['host_os'] =~ /darwin/
      system "open #{link}"
    elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
      system "xdg-open #{link}"
    end
    return self
  end

  private

  # Wrap the content generated by visualization methods
  def publish(title, content, index:false)
    if index
      FileUtils.cp(File.expand_path('../../lib/d3.min.js', __FILE__), wd)
      FileUtils.cp(File.expand_path('../../lib/jquery.min.js', __FILE__), wd)
      File.open(path_to('index.html'), 'w').puts <<-END_OF_DOC
<!DOCTYPE html>
<html style="overflow: hidden;">
<head>
  <meta charset="utf-8">
  <title>#{title}</title>
  <script src="d3.min.js" charset="utf-8"></script>
  <script src="jquery.min.js" charset="utf-8"></script>
  <style> 
    * { margin: 0; padding: 0;}
  </style>
</head>
<body>
#{content}
</body>
</html>
      END_OF_DOC
    else
      File.open(path_to(title.to_s), 'w').puts content
    end
  end
end

require "biotcm/scripts/d3/bar"
