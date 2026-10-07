require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "returns http success" do
      # トップページ（ / ）にアクセスして成功することをテストする
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /terms" do
    it "returns http success" do
      # 利用規約ページ（ /terms ）にアクセスして成功することをテストする
      get terms_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy" do
    it "returns http success" do
      # プライバシーポリシーページ（ /privacy ）にアクセスして成功することをテストする
      get privacy_path
      expect(response).to have_http_status(:success)
    end
  end
end
