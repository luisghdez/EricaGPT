class Message < ApplicationRecord
  validates :sender, :content, presence: true
  belongs_to :history
end
