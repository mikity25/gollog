require 'rails_helper'

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  describe "Googleログイン" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: "google_oauth2",
        uid: "123456",
        info: {
          name: "テストユーザー",
          email: "test@example.com"
        }
      })

      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    context "ユーザーがまだ存在しない場合（新規登録）" do
      it "正常に認証され、新規ユーザーが作成されてトップページにリダイレクトされること" do
        expect {
          get user_google_oauth2_omniauth_callback_path
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(root_path)
      end
    end

    context "すでに同じメールアドレスのユーザーが手動登録済みの場合" do
      # あらかじめ同じメアドのユーザーをデータベースに作っておく
      let!(:existing_user) { create(:user, email: "test@example.com", provider: nil, uid: nil) }

      it "新規作成されず、既存ユーザーにGoogle情報が紐づいてログインできること" do
        expect {
          get user_google_oauth2_omniauth_callback_path
        }.not_to change(User, :count) # ユーザー数は増えない（0件変わる）

        expect(response).to redirect_to(root_path)

        # 既存ユーザーに provider と uid が正しく後付けされたか確認
        expect(existing_user.reload.provider).to eq("google_oauth2")
        expect(existing_user.reload.uid).to eq("123456")
      end
    end
  end
end
