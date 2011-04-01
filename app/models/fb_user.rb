class FBUser
  include Mongoid::Document
  field :first_name, :type => String
  field :last_name, :type => String
  field :name, :type => String
  field :gender, :type => String
  field :fbid, :type => String
  field :fblink, :type => String

  validates_uniqueness_of :fbid

  def self.find_by_fbid(fbid)
    FBUser.first(:conditions => {:fbid => fbid})
  end
end
