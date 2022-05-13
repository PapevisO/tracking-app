class ShortenerNewUrlsController < ApplicationController
  # GET /urls
  def new
    @shortened_url = Shortener::ShortenedUrl.new url: params[:url]
  end

  def create
    @shortened_url = Shortener::ShortenedUrl.generate "https://tracking-app.papievis.com/?url=#{URI.encode(params.dig :shortened_url, :url)}"

    respond_to do |format|
      format.html { redirect_to "https://tracking-app.papievis.com/s/#{@shortened_url.unique_key}", notice: "Record was successfully created." }
      format.json { render :show, status: :created, location: @shortened_url }
    end
  end
end
