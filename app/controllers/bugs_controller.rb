class BugsController < ApplicationController

	 before_action :authenticate_user!

	 respond_to :json
	 
	 def index
        respond_to do |format|
           format.html
           format.json { render json: Bug.by_user(current_user.id) }
        end
	 end

	 def create
	 	respond_with current_user.bugs.create(bug_params)
	 end

	 private
	 def bug_params
	 	params.require(:bug).permit(:summary,:description,:priority)
	 end
end