class TitleController < ApplicationController
  def semafor
    date = Date.today
    @votes = Vote.today_votes(Date.today)
    @can_vote = (session[:votes].nil? || session[:votes][date].nil?)
    Rails.logger.debug(@votes)
    if @votes.values.length == 1
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
    
  end

  def vote
    date = Date.today
    if session[:votes].nil? || session[:votes][date].nil?
      v = Vote.new(:color => params[:color], :date => date)
      v.save
      session[:votes] = {} if session[:votes].nil?
      session[:votes][date] = 1
    end
    redirect_to '/'
  end
end
