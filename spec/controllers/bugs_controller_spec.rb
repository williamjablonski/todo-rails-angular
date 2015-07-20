require 'rails_helper'

RSpec.describe BugsController, :type => :controller do
	render_views

	context "when logged out" do 
	    it "should not be able to access index" do
	      get :index
	      expect(response).to redirect_to(new_user_session_path)
	    end
	end

	context "when logged in" do
      login_user_before_each
      
      before(:each) do
      	@user1 = @current_user
      	@user2 = FactoryGirl.create(:user)
        (0..10).each do |index|
 			FactoryGirl.create(:bug, user: (index % 2 == 0 ? @user1 : @user2))
        end
      end

      it "should return the bugs for the logged user" do
      	 get :index, format: :json
      	 json = JSON.parse(response.body)
      	 user_ids = json.each.collect { |json| json["user_id"] }
         expect(user_ids).to all(eq(@current_user.id))
      end


    describe "#create" do 
       let(:valid_attributes){ FactoryGirl.build(:bug).attributes }
       it "should create a new bug for the current user" do 
        expect {
          xhr :post, :create, format: :json, bug: valid_attributes
          }.to change(@current_user.bugs, :count).by(1)
       end
    end

    describe "#update" do
      before(:each) do
        @bug = FactoryGirl.create(:bug, user: @current_user)
      end
      let(:valid_attributes){ FactoryGirl.build(:bug, description: "my_bug_updated", id: @bug.id).attributes }
       it "should edit a new bug for the current user" do 
          xhr :put, :update, format: :json, id: @bug.id, bug: valid_attributes
          expect(@bug.reload.description).to eq("my_bug_updated")
       end
    end

    describe "#destroy" do 
      it "should destroy the bug" do 
        bug = FactoryGirl.create(:bug, user_id: @current_user.id)
        expect {
          xhr :delete, :destroy, format: :json, id: bug.id
          }.to change(@current_user.bugs, :count).by(-1)
      end

      it "should not destroy other user's bug" do
        bug = FactoryGirl.create(:bug)
        expect {
          xhr :delete, :destroy, format: :json, id: bug.id
          }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
   end
end
