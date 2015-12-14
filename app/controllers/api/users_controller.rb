class Api::UsersController < ApiController

  def index
    users = User.all

    render json: users, each_serializer: UserSerializer
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: { error: "You can not delete a user account through the API. Please visit the website if you wish to proceed with this action." }, status: :forbidden
  end


  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
