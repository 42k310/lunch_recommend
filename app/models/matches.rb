class Matches < ActiveRecord::Base
  belongs_to :shops
  belongs_to :questions
end
