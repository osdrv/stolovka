class Vote
  include Mongoid::Document
  field :color
  field :date, :type => Date

  def self.today_votes(date)
    criteria = Vote.where(:date => date)
    {
      :red => criteria.where(:color => 'red').count,
      :yellow => criteria.where(:color => 'yellow').count,
      :green => criteria.where(:color => 'green').count
    }
  end
end
