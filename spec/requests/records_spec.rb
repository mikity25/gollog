require 'rails_helper'

RSpec.describe 'Records', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:record) { create(:record, user: user) }

  before do
    sign_in user
  end

  describe 'PATCH /records/:id (カルテ更新)' do
    context '画像を追加する場合' do
      it '既存の画像が削除されず、新しい画像が追加されて合計枚数が増えること' do
        # 1. 事前に画像を1枚添付しておく
        record.images.attach(
          io: StringIO.new('initial image content'),
          filename: 'initial.jpg',
          content_type: 'image/jpeg'
        )
        expect(record.images.count).to eq(1)

        # 2. 追加する2枚目のダミー画像を用意
        new_image = fixture_file_upload(
          Rails.root.join('spec/fixtures/files/dummy.jpg'),
          'image/jpeg'
        ) rescue Rack::Test::UploadedFile.new(
          StringIO.new('second image content'),
          'image/jpeg',
          original_filename: 'second.jpg'
        )

        # 3. 編集フォームから新しい画像を追加して更新リクエストを送信
        patch record_path(record), params: {
          record: {
            golf_course_name: record.golf_course_name,
            images: [ new_image ]
          }
        }

        # 4. 詳細画面にリダイレクトされること
        expect(response).to redirect_to(record_path(record))

        # 5. 画像が総入れ替えされず、1枚から2枚に増えていることを検証
        expect(record.reload.images.count).to eq(2)
      end
    end

    context '登録済み画像を削除する場合' do
      it '指定された画像が物理削除（purge）されること' do
        # 事前に2枚添付
        2.times do |i|
          record.images.attach(
            io: StringIO.new("content #{i}"),
            filename: "image_#{i}.jpg",
            content_type: 'image/jpeg'
          )
        end
        expect(record.images.count).to eq(2)

        target_image = record.images.first

        # 1枚目を削除指定して更新リクエストを送信
        patch record_path(record), params: {
          record: {
            golf_course_name: record.golf_course_name,
            purge_image_ids: [ target_image.id ]
          }
        }

        expect(response).to redirect_to(record_path(record))
        # 1枚が削除されて残り1枚になっていること
        expect(record.reload.images.count).to eq(1)
        expect(record.images).not_to include(target_image)
      end
    end
  end
end
