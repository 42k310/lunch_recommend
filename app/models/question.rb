class Question < ActiveRecord::Base
  has_many :answer_histories
  has_one :match
end
