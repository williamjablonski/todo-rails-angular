class Bug < ActiveRecord::Base
	validates_presence_of :summary, :description, :priority
	belongs_to :user

	scope :by_user, ->(user_id){ where(user_id: user_id) }
end
