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

  context 'PUT#update' do
    it 'updates the goal with the correct parameters' do
      user = create(:user)
      goal = create(:goal, user: user, name: "the original name")
      headers = json_request_headers
      headers['Authorization'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)
      params = { name: "a new name that is different" }

      put '/api/goals/1', params.to_json, headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["goal"]).to eq({ "id" => 1, "name" => "a new name that is different", "created_at" => Time.now.strftime('%B %d %Y') })
    end

    it 'returns an error if the requested goal can not be found' do
      user = create(:user)
      goal = create(:goal, user: user, name: "the original name")
      headers = json_request_headers
      headers['Authorization'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,user.password)
      params = { name: "a new name that is different" }

      put '/api/goals/2', params.to_json, headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json).to eq({ "error" => "The specified goal was not found" })
    end
  end
end
