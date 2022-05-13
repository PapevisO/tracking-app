class MainController < ApplicationController
  before_action :set_record, only: %i[ show edit update destroy ]

  # GET /
  def index   
    AMQP::Queue.enqueue :record, to_payload, {}
    
    if request.query_parameters[:url]
      redirect_to request.query_parameters[:url], :status => 301
    else
      respond_to do |format|
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: request.referrer, status: :unprocessable_entity }
      end
    end
  end

  private

    def remote_ip
      # default behaviour, IP from HTTP_X_FORWARDED_FOR
      ip = request.env["HTTP_X_FORWARDED_FOR"]
      ip ||= request.env['action_dispatch.remote_ip'].to_s
  
      if TrackingApp::App.config.gateway == 'akamai'
        # custom header that contains only client IP
        true_client_ip = request.env['HTTP_TRUE_CLIENT_IP'].to_s
        # take IP from TRUE_CLIENT_IP only if its not nil or empty
        ip = true_client_ip unless true_client_ip.nil? || true_client_ip.empty?
      end
  
      Rails.logger.debug "User login IP address: #{ip}"
      return ip
    end

    def to_payload
      {
        uuid: request.env['action_dispatch.request_id'].to_s,
        ip: remote_ip,
        visited_at: Time.current,
        http_sec: request.env.each_pair.with_object({}) do |(key,value), http_sec|
          http_sec[key.delete_prefix('HTTP_SEC_').downcase] = value if key.match? /HTTP_SEC/
        end,
        referrer: request.referrer,
        url: request.query_parameters[:url],
        language: request.accept_language
      }
    end
end