require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:my_user)   { create(:user) }

  describe "POST #create" do
    before do
      sign_in(my_user)
    end

    it "adds a new goal for the current user" do
      goals_size = Goal.where(user_id: my_user.id).length
      post :create, user_id: my_user.id, goal: { name: RandomData.random_goal }
      expect(Goal.where(user_id: my_user.id).length).to eq(goals_size + 1)
    end

    it "assigns the new goal to @goal" do
      post :create, user_id: my_user.id, goal: { name: RandomData.random_goal }
      expect(assigns(:goal)).to eq(Goal.last)
    end

    it "assigns the goal with the correct attributes" do
      post :create, user_id: my_user.id, goal: { name: "do the laundry" }
      my_goal = my_user.goals.first
      expect(my_goal.name).to eq("do the laundry")
    end

    it "redirects to user #show page" do
      post :create, user_id: my_user.id, goal: { name: RandomData.random_goal }
      expect(response).to redirect_to(user_path(my_user.id))
    end
  end

  describe "DELETE #destroy" do
    it "responds with http status 200 ok" do
      user = create(:user)
      goal = create(:goal, user: user)

      sign_in(user)

      delete :destroy, format: :js, id: goal.id
      expect(response).to have_http_status(200)
    end

    it "deletes the expected goal" do
      user = create(:user)
      goal = create(:goal, user: user)

      sign_in(user)

      delete :destroy, format: :js, id: goal.id
      expect(Goal.count).to eq(0)
    end

    it "deletes only the expected goal" do
      user = create(:user)
      goal = create(:goal, user: user)
      second_goal = create(:goal, user: user)

      sign_in(user)

      delete :destroy, format: :js, id: goal.id
      expect(Goal.count).to eq(1)
    end

    it "does not delete goal belonging to another user" do
      user = create(:user)
      goal = create(:goal, user: user)
      other_user = create(:user)

      sign_in(other_user)

      expect do
        delete :destroy, format: :js, id: goal.id
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "sets the successful flash message" do
      user = create(:user)
      goal = create(:goal, user: user)

      sign_in(user)

      delete :destroy, format: :js, id: goal.id
      expect(flash[:notice]).to eq("Goal completed successfully!")
    end

    it "responds with http status 404 not found for unkown goal" do
      user = create(:user)

      sign_in(user)

      expect do
        delete :destroy, format: :js, id: 2
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "sets the error flash when destroy fails" do
      user = create(:user)
      goal = instance_double("Goal")
      expect(goal).to receive(:destoroy).and_return(false)
      goal_id = "123"
      expect(Goal).to receive(:find).with(goal_id).and_return(goal)

      sign_in(user)

      delete :destroy, format: :js, id: goal_id

      expect(flash[:error]).to eq("There was an error marking your goal completed.")
    end
  end
end
