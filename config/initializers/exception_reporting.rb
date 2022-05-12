# encoding: UTF-8
# frozen_string_literal: true

def catch_and_report_exception(options = {})
  begin
    yield
    nil
  rescue options.fetch(:class) { StandardError } => e
    report_exception(e)
    e
  end
end

# report_api_error sample output.
# With default Rails formatter:
# I, [2019-09-18T12:52:59.077389 #157366]  INFO -- : {:message=>"Record is invalid", :path=>"/redirect", :params=>{"uuid"=>"00000000-0000-0000-0000-000000000000", "datetime"=>"2022-05-12T22:03:57+00:00", "ip"=>"200.20.2.2", "location"=>"Antarctic", "os"=>"MS DOS", "device"=>"Turing machine", "referrer"=>"https://tracking-app.papievis.com", "url"=>"https://tracking-app.papievis.com", "language"=>"EN_en"}}
#
# With JSONLogFormatter:
# {"message":"Record is invalid","path":"/redirect","params":{"uuid":"00000000-0000-0000-0000-000000000000","datetime":"2022-05-12T22:03:57+00:00","ip":"200.20.2.2","location":"Antarctic","os":MS DOS,"device":"Turing machine","referrer":"https://tracking-app.papievis.com","url":"https://tracking-app.papievis.com","language":"EN_en"},"level":"INFO","time":"2019-09-18 12:54:36"}

def report_api_error(exception, request)
  Rails.logger.info message: exception.message, path: request.path, params: request.params
end

def report_exception(exception, report_to_ets = true)
  report_exception_to_screen(exception)
  report_exception_to_ets(exception) if report_to_ets
end

def report_exception_to_screen(exception)
  Rails.logger.error(exception.inspect)
  Rails.logger.error(exception.backtrace.join("\n")) if exception.respond_to?(:backtrace)
end

def report_exception_to_ets(exception)
  Raven.capture_exception(exception) if defined?(Raven)
rescue => ets_exception
  report_exception(ets_exception, false)
end
