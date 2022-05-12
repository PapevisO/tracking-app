# Examples:
# logger = TaggedLogger(Rails.logger, app: 'app')
# logger.info 'record processed'
# # I, [2019-07-04T18:56:02.977542 #7987]  INFO -- : {:app=>"app", :message=>"record processed"}

# with json format
# logger = TaggedLogger.new(Rails.logger, app: 'app')
# logger_extended = TaggedLogger.new(logger, version: '2.2', branch: 'master')
#
# logger.info 'record processed'
# # {"app":"app","message":"record processed","level":"INFO","time":"2019-07-04 18:59:01"}
#
# logger_extended.info 'record processed'
# # {"app":"app","version":"2.2","branch":"master","message":"record processed","level":"INFO","time":"2019-07-04 18:59:09"}

class TaggedLogger
  def initialize(logger, tags)
    @logger = logger.dup
    @tags = tags
  end

  [:fatal, :error, :warn, :info, :debug].each do |log_method|
    define_method(log_method) do |msg|
      if msg.is_a? Hash
        msg = @tags.merge msg
      else
        msg = @tags.merge(message: msg)
      end

      @logger.method(log_method).call(msg)
    end
  end
end
