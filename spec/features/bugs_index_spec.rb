#encoding: UTF-8
require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!


RSpec.describe "Bugs Index", :type => :feature, :js => true do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end

  after(:each) do 
    Warden.test_reset! 
  end

  context "List Bugs" do
    before(:each) do
      FactoryGirl.create(:bug, user: @user)
    end
    
    it "should show the list of bugs" do
      visit "/bugs"
      expect(page).to have_text("Bugs I have found so far")
      expect(page.all(".bug-row").size).to eq 1
    end
  end

end