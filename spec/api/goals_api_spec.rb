require 'rails_helper'

describe '/api/goals' do
  def basic_credentials(email, password)
    ActionController::HttpAuthentication::Basic.encode_credentials(email,password)
  end

  def formatted_time(time)
    time.strftime('%B %d %Y')
  end

  context 'GET#index' do

    context 'with correct credentials' do
      it 'returns a list of current_user goals as JSON' do
        user = create(:user)
        goals = create_list(:goal, 3, user: user)
        headers = json_request_headers
        headers['Authorization'] = basic_credentials(user.email,user.password)

        get '/api/goals/', {}, headers
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(json['goals'].length).to eq(3)

        goals.each_with_index do |goal, i|
          expected_hash = {
            "id" => goals[i].id,
            "name" => goals[i].name,
            "created_at" => formatted_time(goals[i].created_at)
          }

          expect(json['goals'][i]).to eq(expected_hash)
        end
      end
    end
  end

  context 'GET#create' do

    context 'with correct parameters' do
      it 'creates a new goal as the current_user' do
        user = create(:user)
        headers = json_request_headers
        headers['Authorization'] = basic_credentials(user.email,user.password)
        params = { name: "the name of the goal" }

        expect{ post '/api/goals/', params.to_json, headers }.to change(Goal,:count).by(1)
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(json).to eq({ "goal" => { "id" => Goal.last.id, "name" => "the name of the goal", "created_at" => formatted_time(Time.now) }})
      end
    end

    context 'with incorrect parameters' do
      it 'returns an error' do
        user = create(:user)
        headers = json_request_headers
        headers['Authorization'] = basic_credentials(user.email,user.password)
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
      headers['Authorization'] = basic_credentials(user.email,user.password)
      params = { name: "a new name that is different" }

      put "/api/goals/#{goal.id}", params.to_json, headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["goal"]).to eq({ "id" => goal.id, "name" => "a new name that is different", "created_at" => formatted_time(Time.now) })
    end

    it 'returns an error if the requested goal can not be found' do
      user = create(:user)
      headers = json_request_headers
      headers['Authorization'] = basic_credentials(user.email,user.password)
      params = { name: "a new name that is different" }

      put '/api/goals/2', params.to_json, headers
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:not_found)
      expect(json).to eq({ "error" => "The specified goal was not found" })
    end
  end
end
