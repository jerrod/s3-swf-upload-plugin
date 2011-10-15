module S3SwfUpload
  module ViewHelpers

    def s3_swf_upload_tag(options = {}, swf_id='1')
      out = ''
      out << "\n<script type=\"text/javascript\">\n"
      out << "\tvar s3_swf_#{swf_id}_object = s3_swf_init('s3_swf_#{swf_id}', #{setup_defaults_and_callbacks(options)});\n"
      out << "</script>\n"
      out << "<div id=\"s3_swf_#{swf_id}\">\n"
      out << "Please <a href=\"http://www.adobe.com/go/getflashplayer\">Update</a> your Flash Player to Flash v#{options['flashVersion'].to_s} or higher...\n"
      out << "</div>\n"
      out
    end

    def sensible_defaults
      {:buttonWidth => 100,
       :buttonHeight => 30,
       :height => '9.0.0',
       :queueSizeLimit => 100,
       :fileSizeLimit => 524288000,
       :fileTypes => '*.*',
       :fileTypeDescs => 'All Files',
       :selectMultipleFiles => true,
       :keyPrefix => '',
       :signaturePath => '/s3_uploads.xml',
       :buttonUpPath => '/flash/s3_up_button.gif',
       :buttonOverPath => '/flash/s3_over_button.gif',
       :buttonDownPath => '/flash/s3_down_button.gif',
       :onFileAdd => false,
       :onFileRemove => false,
       :onFileSizeLimitReached => false,
       :onFileNotInQueue => false,
       :onQueueChange => false,
       :onQueueClear => false,
       :onQueueSizeLimitReached => false,
       :onQueueEmpty => false,
       :onUploadingStop => false,
       :onUploadingStart => false,
       :onUploadingFinish => false,
       :onSignatureOpen => false,
       :onSignatureProgress => false,
       :onSignatureHttpStatus => false,
       :onSignatureComplete => false,
       :onSignatureSecurityError => false,
       :onSignatureIOError => false,
       :onSignatureXMLError => false,
       :onUploadOpen => false,
       :onUploadProgress => false,
       :onUploadHttpStatus => false,
       :onUploadComplete => false,
       :onUploadIOError => false,
       :onUploadSecurityError => false,
       :onUploadError => false
    	}
    end

    def setup_defaults_and_callbacks(options)
      options = sensible_defaults.merge(options)
      options_array = []
      options.collect do |key, value|
        options_array << case key
          when :onFileAdd, :onFileRemove, :onFileSizeLimitReached, :onFileNotInQueue
               "#{key}:function(file){ #{value} }" if value
          when :onQueueChange, :onQueueSizeLimitReached, :onQueueEmpty, :onQueueClear
               "#{key}:function(queue){ #{value} }" if value
          when :onUploadingStart, :onUploadingStop, :onUploadingFinish
               "#{key}:function(){ #{value} }" if value
          when :onSignatureOpen, :ononSignatureComplete
               "#{key}:function(file,event){ #{value} }" if value
          when :onSignatureProgress
               "#{key}:function(file,progress_event){ #{value}}" if value
          when :onSignatureSecurityError
               "#{key}:function(file,security_error_event){ #{value} }" if value
          when :onSignatureIOError
               "#{key}:function(file,io_error_event){ #{value} }" if value
          when :onSignatureHttpStatus
               "#{key}:function(file,http_status_event){ #{value} }" if value
          when :onSignatureXMLError
               "#{key}:function(file,error_message){ #{value} }" if value
          when :onUploadError
               "#{key}:function(upload_options,error){ #{value} }" if value
          when :onUploadOpen
               "#{key}:function(upload_options,event){ #{value} }" if value
          when :onUploadProgress
               "#{key}:function(upload_options,progress_event){ #{value} }" if value
          when :onUploadIOError
               "#{key}:function(upload_options,io_error_event){ #{value} }" if value
          when :onUploadHttpStatus
               "#{key}:function(upload_options,http_status_event){ #{value} }" if value
          when :onUploadSecurityError
               "#{key}:function(upload_options,security_error_event){ #{value} }" if value
          when :onUploadComplete
               "#{key}:function(upload_options,event){ #{value} }" if value
          when :scriptData
            ["#{key}:#{value.to_json}","postData:#{value.to_json}"] if value
          else
            key.to_s+':"'+value.to_s+'"' if value
        end
      end
      return "{#{options_array.flatten.compact.uniq.sort.join(",\n")}}"
    end
  end
end

ActionView::Base.send(:include, S3SwfUpload::ViewHelpers)
