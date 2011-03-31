class Menu
  include Mongoid::Document
  field :first, :type => String
  field :second, :type => String
  field :salad, :type => String
  field :drink, :type => String
  field :date, :type => Date

  before_validation :set_date

  validates_uniqueness_of :date

  def self.today(date)
    Menu.first(:conditions => { :date => date })
  end

  def set_date
    self.date = Date.today
  end
end
