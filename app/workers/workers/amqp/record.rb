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

        @logger.warn 'Unable to insert.'\
          "Processor failed for : #{payload}"
      rescue StandardError => e
        raise e if is_db_connection_error?(e)

        report_exception(e)
      end
    end
  end
end
