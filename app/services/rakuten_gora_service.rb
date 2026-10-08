# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

class RakutenGoraService
  BASE_URL = "https://openapi.rakuten.co.jp/engine/api/Gora/GoraGolfCourseSearch/20170623"
  APP_HOST = "https://gollog.onrender.com"

  def initialize(keyword)
    @keyword = keyword.to_s.strip
  end

  # ゴルフ場名の配列を返す
  def search_golf_courses
    return [] if @keyword.blank?

    response = fetch_from_api
    parse_response(response)
  rescue StandardError => e
    Rails.logger.error("Rakuten GORA API Error: #{e.message}")
    []
  end

  private

  def fetch_from_api
    uri = URI(BASE_URL)
    params = {
      format: "json",
      applicationId: ENV.fetch("RAKUTEN_APPLICATION_ID", nil),
      accessKey: ENV.fetch("RAKUTEN_ACCESS_KEY", nil),
      keyword: @keyword,
      hits: 10
    }
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 5
    http.read_timeout = 5

    request = Net::HTTP::Get.new(uri)
    # 楽天Developersで許可されたオリジン/リファラをヘッダーに付与
    request["Referer"] = APP_HOST
    request["Origin"] = APP_HOST

    http.request(request)
  end

  def parse_response(response)
    return [] unless response.is_a?(Net::HTTPSuccess)

    # 文字コードをUTF-8に明示してパース
    body = response.body.force_encoding("UTF-8")
    data = JSON.parse(body)
    items = data["Items"] || []

    # 各ゴルフ場データから名前（golfCourseName）のみを抽出
    items.filter_map do |entry|
      item = entry["Item"] || entry
      item["golfCourseName"]
    end
  end
end