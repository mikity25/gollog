require 'rails_helper'

RSpec.describe "ゲストログイン機能", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "トップページからのゲストログイン" do
    it "ゲストログインボタンを押すとログインでき、カルテ一覧が表示されること" do
      visit root_path

      # ゲストログインのPOSTフォームのボタンを押す
      find("form[action='#{guest_sign_in_path}'] button").click

      expect(page).to have_content("ログアウト")
      expect(page).to have_content("カルテ")
    end
  end

  describe "ログイン画面からのゲストログイン" do
    it "お試しリンクを押すとログインできること" do
      visit new_user_session_path

      # 文言に依存せず、ゲストログイン用の送信ボタンを確実にクリック
      find("form[action='#{guest_sign_in_path}'] button").click

      expect(page).to have_content("ログアウト")
    end
  end
end
