require 'rails_helper'

feature "user completes goal", js: true do

  scenario "successfully" do
    user = create(:user)
    goal = create(:goal, user: user)

    visit "/users/sign_in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "Profile"

    expect(page).to have_content(goal.name)

    click_button "Completed"

    fill_in "", with: user.email
    fill_in "", with: user.password
    click_button "Log In"

    expect(page).to have_no_content(goal.name)
    expect(current_path).to eq("/users/#{user.id}")

    flash_message = "Goal completed successfully!"
    expect(page).to have_content(flash_message)
  end
end
