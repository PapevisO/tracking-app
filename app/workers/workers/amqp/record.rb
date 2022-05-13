# encoding: UTF-8
# frozen_string_literal: true

module Workers
  module AMQP
    class Record < Base
      def initialize
        @logger = TaggedLogger.new(Rails.logger, worker: __FILE__)
      end

      def process(payload)
        payload.symbolize_keys!
        payload[:http_sec].symbolize_keys!

        record = ::Record.create(
          uuid: payload[:uuid],
          visited_at: payload[:visited_at],
          ip: payload[:ip],
          location: TrackingApp::GeoIP.info(ip: payload[:ip], key: :country),
          os: payload.dig(:http_sec, :ch_ua_platform),
          device: payload.dig(:http_sec, :ch_ua),
          referrer: payload[:referrer],
          url: payload[:url],
          language: payload[:language],
        )

        @logger.warn 'Unable to insert.'\
          "Processor failed for : #{payload}" unless record
      rescue StandardError => e
        raise e if is_db_connection_error?(e)

        report_exception(e)
      end
    end
  end
end
