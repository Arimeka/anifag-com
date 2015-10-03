module Paperclip
  module Storage::S3
    def public_url(attachment, style = default_style, gravity = 'north')
      "#{attachment.s3_protocol(style, true)}//#{@options[:s3_custom_host]}/#{custom_path(style, gravity)}"
    end

    def custom_path(style_name = default_style, gravity = 'north')
      path = original_filename.nil? ? nil : custom_interpolate(custom_path_option, style_name, gravity)
      path.respond_to?(:unescape) ? path.unescape : path
    end

    def custom_path_option
      @options[:path].respond_to?(:call) ? @options[:path].call(self) : @options[:path].gsub(':basename', ':custom_basename')
    end

    def custom_interpolate(pattern, style_name = default_style, gravity = 'north') #:nodoc:
      interpolator.custom_interpolate(pattern, self, style_name, gravity)
    end
  end

  module Interpolations
    def self.custom_interpolate pattern, *args
      pattern = args.first.instance.send(pattern) if pattern.kind_of? Symbol
      all.reverse.inject(pattern) do |result, tag|
        result.gsub(/:#{tag}/) do |match|
          if tag == :custom_basename
            send( tag, *args )
          else
            send( tag, args[0], args[1] )
          end
        end
      end
    end

    def custom_basename attachment, style_name, gravity = 'north'
      file = attachment.original_filename.gsub(/#{Regexp.escape(File.extname(attachment.original_filename))}\Z/, "")
      "gr/#{gravity}/s/#{style_name}/#{file}"
    end
  end
end

Paperclip.interpolates(:s3_custom_url) do |attachment, style|
  attachment.public_url(attachment, style)
end
