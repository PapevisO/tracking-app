class StatsController < ApplicationController
  # GET /records or /records.json
  def index
    @records = Record.group(:url).count
    @records['unknown'] = @records.delete nil
  end
end
