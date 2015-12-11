class Api::GoalsController < ApiController
  before_action :authenticated?

  def create
    user = User.find(params[:user_id])
    goal = user.goals.build(goal_params)

    if goal.save
      render json: goal
    else
      render json: { errors: goal.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def goal_params
    params.require(:goal).permit(:name)
  end
end
