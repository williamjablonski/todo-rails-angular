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

  context "Create Bugs" do
    it "should create a bug when all the information is filled" do
      visit "/bugs"
      find("#show_form").click
      fill_in "summary", with: "Test summary"
      fill_in "description", with: "Test bug-description"
      select "Medium", from: "priority"
      click_button "Add"
      expect(page.all(".bug-row").size).to eq 1
      create_bug = Bug.all.first
      expect(create_bug.summary).to eq "Test summary"
      expect(create_bug.description).to eq "Test bug-description"
      expect(create_bug.priority).to eq "MEDIUM"
    end

     it "should not create a bug when not all the information is filled" do
      visit "/bugs"
      find("#show_form").click
      click_button "Add"
      expect(page.all(".bug-row").size).to eq 0
    end
  end

end