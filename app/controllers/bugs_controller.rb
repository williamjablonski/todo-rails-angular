class BugsController < ApplicationController

	 before_action :authenticate_user!

	 respond_to :json
	 
	 def index
        respond_to do |format|
           format.html
           format.json { render json: Bug.by_user(current_user.id) }
        end
	 end
end
