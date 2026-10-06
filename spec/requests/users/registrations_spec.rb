require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:guest_user) { User.guest }

  before do
    sign_in guest_user
  end

  describe "PATCH /users (アカウント更新)" do
    it "更新が遮断され、root_pathにリダイレクトされること" do
      patch user_registration_path, params: { user: { name: "変更後ネーム" } }
      expect(response).to redirect_to(root_path)
      expect(guest_user.reload.name).to eq("ゲストゴルファー")
    end
  end

  describe "DELETE /users (アカウント削除)" do
    it "削除が遮断され、アカウントが残ること" do
      expect {
        delete user_registration_path
      }.not_to change(User, :count)

      expect(response).to redirect_to(root_path)
    end
  end
end
