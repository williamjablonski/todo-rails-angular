require 'rails_helper'

RSpec.describe Bug, :type => :model do
    subject { FactoryGirl.create(:bug) }
    context "Validations" do 

    [:summary, :description, :priority].each do |attribute|
      it "should not be valid without #{attribute}" do 
        subject.send("#{attribute}=", '')
        expect(subject).not_to be_valid
      end
    end

  end

  context "Scopes" do
  	before(:each) do
  		@user1 = FactoryGirl.create(:user)
  		@user2 = FactoryGirl.create(:user)
  		@user3 = FactoryGirl.create(:user)
  		@bug1 = FactoryGirl.create(:bug, user: @user1)
  		@bug2 = FactoryGirl.create(:bug, user: @user2)
  	end

  	it "should only return results for an specific user" do
         bugs = Bug.by_user(@user2.id)
         expect(bugs.count).to eq 1
         expect(bugs.first).to eq @bug2
  	end

  	it "should return no results if there are no bugs for that user" do
  		bugs = Bug.by_user(@user3)
  		expect(bugs).to be_empty
  	end
  end
end
