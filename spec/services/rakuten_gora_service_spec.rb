# frozen_string_literal: true

require "rails_helper"

RSpec.describe RakutenGoraService, type: :service do
  describe "#search_golf_courses" do
    context "キーワードが空の場合" do
      it "APIと通信せず空の配列を返すこと" do
        service = described_class.new("")
        expect(service.search_golf_courses).to eq []
      end
    end

    context "キーワードが入力されている場合" do
      let(:service) { described_class.new("富士") }

      it "正常にレスポンスが返ってきたとき、ゴルフ場名の配列を返すこと" do
        dummy_response = instance_double(
          Net::HTTPSuccess,
          is_a?: true,
          body: {
            "Items" => [
              { "Item" => { "golfCourseName" => "富士カントリークラブ" } },
              { "Item" => { "golfCourseName" => "富士笠間ゴルフ倶楽部" } }
            ]
          }.to_json
        )

        allow(service).to receive(:fetch_from_api).and_return(dummy_response)

        result = service.search_golf_courses
        expect(result).to eq ["富士カントリークラブ", "富士笠間ゴルフ倶楽部"]
      end

      it "通信エラーや予期せぬ例外が発生したとき、アプリを落とさず空の配列を返すこと（フォールバック）" do
        allow(service).to receive(:fetch_from_api).and_raise(StandardError.new("API Down"))

        expect { result = service.search_golf_courses }.not_to raise_error
        expect(service.search_golf_courses).to eq []
      end
    end
  end
end