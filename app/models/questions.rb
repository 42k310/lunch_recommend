class Questions < ActiveRecord::Base
  has_many :answer_histories
  has_one :matches
end
