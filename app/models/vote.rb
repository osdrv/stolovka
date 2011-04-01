class Vote
  include Mongoid::Document
  field :color
  field :date, :type => Date
  field :uid

  validates_uniqueness_of :uid, :scope => :date

  def self.today_votes(date)
    criteria = Vote.where(:date => date)
    {
      :red => criteria.where(:color => 'red'),
      :yellow => criteria.where(:color => 'yellow'),
      :green => criteria.where(:color => 'green')
    }
  end

  def self.user_voted?(uid, date)
    Vote.where(:date => date, :uid => uid).count > 0
  end
end
