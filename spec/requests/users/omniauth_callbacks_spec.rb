require 'rails_helper'

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  describe "Googleログイン" do
    it "正常に認証され、ログインしてトップページにリダイレクトされること" do
      # テスト用の偽の認証データとDeviseのマッピングを紐付ける
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]

      # 認証用パスにアクセスしたとき、Userが1人増えて（新規登録＆ログイン）ルートパスに飛ぶことを検証
      expect {
        get user_google_oauth2_omniauth_callback_path
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end
  end
end
