class Api::GoalsController < ApiController

  def index
    render json: current_user.goals, each_serializer: GoalSerializer
  end

  def create
    begin
      goal = current_user.goals.build(goal_params)

      if goal.save
        render json: goal
      else
        render json: { errors: goal.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActionController::ParameterMissing
      render json: { error: "Incorrect parameters" }, status: :bad_request
    end
  end

  def update
    begin
      goal = current_user.goals.find(params[:id])

      if goal.update(goal_params)
        render json: goal
      else
        render json: { errors: goal.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "The specified goal was not found" }, status: :not_found
    end
  end

  def destroy
    begin
      goal = current_user.goals.find(params[:id])
      goal.destroy
      render json: { message: "The specified goal was deleted" }, status: :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: "The specified goal was not found" }, status: :not_found
    end
  end


  private

  def goal_params
    params.require(:goal).permit(:name)
  end
end
