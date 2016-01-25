class Match < ActiveRecord::Base
  belongs_to :shops
  belongs_to :questions
end
