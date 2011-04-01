class TitleController < ApplicationController
  def semafor
    @date = params[:date] || Date.today
    @date = Date.parse(@date) if @date.is_a? String
    @votes = Vote.today_votes(@date)
    @votes_count = {}
    @votes.each_pair do |k, v|
      @votes_count[k] = v.count
    end
    if @votes_count.values.uniq.length == 1
      @color = nil
    else
      max_votes = 0
      @votes_count.each_pair do |k, v|
        if v >= max_votes
          @color = k
          max_votes = v
        end
      end
    end
    @menu = Menu.today(@date)
    @has_tomorrow_link = (@date < Date.today)
    @is_today = (@date === Date.today)
    @user = init_user
    @can_vote = (@is_today && !@user.nil? && !Vote.user_voted?(@user.fbid, @date))
  end

  def vote
    date = Date.today
    user = init_user
    is_today = (date === Date.today)
    can_vote = (is_today && !user.nil? && !Vote.user_voted?(user.fbid, date))
    if can_vote
      v = Vote.new(:color => params[:color], :date => date, :uid => user.fbid)
      v.save
    end
    redirect_to '/'
  end

private

  def init_user

    fb_sess = nil

    cookies.each_pair do |k, v|
      if k.match(/^fbs_/)
        fb_sess = v
        break
      end
    end

    if fb_sess.nil?
      session.delete(:fbid)
      return nil
    end

    user = nil
    
    if !session[:fbid].nil?
      user = FBUser.find_by_fbid(session[:fbid])
    end

    if user.nil?
      fb_sess_h = {}
      fb_sess.gsub('"', '').split('&').each do |el|
        (k, v) = el.split('=')
        fb_sess_h[k.to_sym] = v
      end

      return nil if fb_sess_h[:uid].nil?

      user_data = MiniFB.get(fb_sess_h[:access_token], fb_sess_h[:uid])

      return nil if !user_data.any?

      user = FBUser.find_by_fbid(user_data[:id]) || FBUser.new

      user.update_attributes(:fbid => user_data[:id], :first_name => user_data[:first_name], :last_name => user_data[:last_name], :name => user_data[:name], :fblink => user_data[:link], :gender => user_data[:gender])
      session[:fbid] = user.fbid
    end

    user
  end
end
