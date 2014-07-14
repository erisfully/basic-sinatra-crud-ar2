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

      fill_in("username", :with => "Ash")
      fill_in("password", :with => "123")

      click_button("Submit")


      expect(page).to have_content("Thank you for registering!")

      visit "/"

      expect(page).to_not have_content("Thank you for registering!")

      visit "/"

      fill_in("username", :with => "Ash")
      fill_in("password", :with => "123")

      click_button("Login")

      save_and_open_page

      expect(page).to have_content("Welcome, Ash!")

      expect(page).to_not have_button("Register", "Login")
      expect(page).to have_button("Logout")

    end
  end