module ApplicationHelper
  require 'date'

  def next_business_day(date)
    skip_weekends(date, 1)
  end    

  def previous_business_day(date)
    skip_weekends(date, -1)
  end

  def skip_weekends(date, inc)
    date += inc
    while is_weekend(date) do
      date += inc
    end   
    date
  end

  def is_weekend(date)
    (date.wday % 7 == 0) || (date.wday % 7 == 6)
  end
end
