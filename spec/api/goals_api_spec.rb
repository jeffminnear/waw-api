require 'rails_helper'

describe '/api/goals' do

  context 'GET#index' do

    context 'with correct credentials' do
      it 'returns a list of current_user goals as JSON' do
        user = create(:user)
        goals = create_list(:goal, 3, user: user)
        headers = json_request_headers
        headers['Authorization'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)

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

  context 'GET#create' do

    context 'with correct parameters' do
      it 'creates a new goal as the current_user' do
        user = create(:user)
        headers = json_request_headers
        headers['Authorization'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)
        params = { name: "the name of the goal" }

        post '/api/goals/', params.to_json, headers
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(json).to eq({ "goal" => { "id" => 1, "name" => "the name of the goal", "created_at" => Time.now.strftime('%B %d %Y') }})
      end
    end

    context 'with incorrect parameters' do
      it 'returns an error' do
        user = create(:user)
        headers = json_request_headers
        headers['Authorization'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)
        params = { title: "the name of the goal" }

        post '/api/goals/', params.to_json, headers
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(json).to eq({ "error" => "Incorrect parameters" })
      end
    end
  end
end
