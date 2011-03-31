class TitleController < ApplicationController
  def semafor
    @date = params[:date] || Date.today
    @date = Date.parse(@date) if @date.is_a? String
    @votes = Vote.today_votes(@date)
    @can_vote = (session[:votes].nil? || session[:votes][@date.to_s].nil?)
    if @votes.values.uniq.length == 1
      @color = nil
    else
      max_votes = 0
      @votes.each_pair do |k, v|
        if v >= max_votes
          @color = k
          max_votes = v
        end
      end
    end
    @menu = Menu.today(@date)
    @has_tomorrow_link = (@date < Date.today)
    @is_today = (@date === Date.today)
    @can_vote = (@can_vote && @is_today)
  end

  def vote
    date = Date.today
    if session[:votes].nil? || session[:votes][date.to_s].nil?
      v = Vote.new(:color => params[:color], :date => date, :ip => request.ip)
      v.save
      session[:votes] = {} if session[:votes].nil?
      session[:votes][date] = 1
    end
    redirect_to '/'
  end
end
