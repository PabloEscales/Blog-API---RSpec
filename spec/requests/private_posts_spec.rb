require "rails_helper"

RSpec.describe " with authentication", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:other_post) { create(:post, user_id: user.id) }
  let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) }
  let!(:other_user_post_draft) { create(:post, user_id: other_user.id, published: false) }
  let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
  let!(:other_auth_headers) { { 'Authorization' => "Bearer #{other_user.auth_token}" } }
  # Authorizationo: Bearer xxxxx (token)

  describe "GET /posts/{id}" do
    context "with valid auth" do
      context "when requisiting other's author post" do
        context "when post is public" do
          before { get "/posts/#{other_user_post.id}", headers: auth_headers }
          context "payload" do
            subject { JSON.parse(response.body) }
            it { is_expected.to include(:id) }
          end
          content "response" do
            subject { response }
            it { is_expected.to have_http_status(:ok) }
        end
      end
      context "when post is draft" do
        before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }
          context "payload" do
            subject { JSON.parse(response.body) }
            it { is_expected.to include(:error) }
          end
          content "response" do
            subject { response }
            it { is_expected.to have_http_status(:not_found) }
        end
      end
    end
    context "when requisiting user's post" do
    end
  end

  describe "POST /posts" do

  end

  describe "PUT /posts" do

  end
  # it "Should return OK" do
  #   get '/posts'
  #   payload = JSON.parse(response.body)
  #   expect(payload).to be_empty
  #   expect(response).to have_http_status(200)
  # end
end
