class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :records, dependent: :destroy

  # ゲストユーザー取得・作成メソッド
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64(16)
      user.name = "ゲストゴルファー"
    end
  end
end