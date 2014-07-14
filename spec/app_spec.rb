require 'spec_helper'

  feature "Homepage" do
    scenario "Has registration button" do

    visit "/"
    expect(page).to have_button("Register")
    end
  end

  feature "Register" do
    scenario "Click register button and see form" do
      visit "/"
      click_button("Register")

      expect(page).to have_content("Username:")
      expect(page).to have_content("Password:")
      expect(page).to have_button("Submit")
      end
    end
