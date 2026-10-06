require 'rails_helper'

RSpec.describe "Users::GuestSessions", type: :request do
  describe "POST /guest_sign_in" do
    it "ゲストユーザーとしてログインでき、リダイレクトされること" do
      post guest_sign_in_path
      expect(response).to redirect_to(records_path).or redirect_to(root_path)
    end

    it "ログイン時にサンプルカルテが5件作成されること" do
      expect {
        post guest_sign_in_path
      }.to change(Record, :count).by(5)
    end

    it "既存のカルテを変更・削除して再ログインした場合でも、常に5件にリフレッシュされること" do
      post guest_sign_in_path
      guest_user = User.find_by(email: "guest@example.com")
      guest_user.records.first.destroy # 1件削除して4件にする
      expect(guest_user.records.count).to eq(4)

      # 再度ゲストログインを実行
      post guest_sign_in_path
      expect(guest_user.records.reload.count).to eq(5)
    end
  end
end
