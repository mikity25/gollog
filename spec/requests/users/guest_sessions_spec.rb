require 'rails_helper'

RSpec.describe "Users::GuestSessions", type: :request do
  describe "POST /guest_sign_in" do
    it "ゲストユーザーとしてログインでき、リダイレクトされること" do
      post guest_sign_in_path
      expect(response).to redirect_to(records_path).or redirect_to(root_path)
    end

    it "初回ログイン時に初期カルテが作成されること" do
      expect {
        post guest_sign_in_path
      }.to change(Record, :count).by_at_least(1)
    end

    it "すでにカルテが存在する場合は重複して増えないこと" do
      post guest_sign_in_path
      delete destroy_user_session_path # ログアウト

      expect {
        post guest_sign_in_path
      }.not_to change(Record, :count)
    end
  end
end
