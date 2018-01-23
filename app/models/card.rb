class Card < ApplicationRecord
  belongs_to :game, required: false
  belongs_to :user, required: false
end
