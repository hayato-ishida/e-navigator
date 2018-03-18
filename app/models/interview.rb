class Interview < ApplicationRecord
	belongs_to :user
	validates :datetime, presence: true
end
