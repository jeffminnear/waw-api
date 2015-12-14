require 'rails_helper'

describe '/api/goals' do

  context 'GET index' do

    context 'with correct credentials' do
      it 'returns a list of current_user goals as JSON' do
        user = create(:user)
        # goal_1 = create(:goal, user: user)
        # goal_2 = create(:goal, user: user)
        # goal_3 = create(:goal, user: user)
        goals = create_list(:goal, 3, user: user)
        headers = json_request_headers
        headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)
        # @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)

        get '/api/goals/', {}, headers
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(json['goals'].length).to eq(3)

        goals.each_with_index do |goal, i|
          expect(json['goals'][i]).to eq({"id" => goals[i].id, "name" => goals[i].name, "created_at" => goals[i].created_at.strftime('%B %d %Y')})
        end
      end
    end
  end
end
