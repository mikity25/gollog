# frozen_string_literal: true

Devise.setup do |config|
  # メール送信元の設定
  config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"

  # ORM（ActiveRecord）のロード
  require "devise/orm/active_record"

  # 認証キーの設定（メールアドレスで認証）
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]

  # 【セキュリティ対策】ユーザー列挙・特定攻撃の防止
  # パスワード再設定などで、メアドの登録有無に関わらず同じメッセージを返してアカウントの存在特定を防ぐ
  config.paranoid = true

  # パスワードハッシュ化のストレッチ回数
  config.stretches = Rails.env.test? ? 1 : 12

  # ログアウト時に「ログイン状態を保持する（Remember me）」トークンを無効化
  config.expire_all_remember_me_on_sign_out = true

  # パスワードの有効な長さ
  config.password_length = 6..128

  # メールアドレスの形式チェック用正規表現
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # パスワード再設定用トークンの有効期限
  config.reset_password_within = 6.hours

  # ログアウト時のHTTPメソッド
  config.sign_out_via = :delete

  # Hotwire / Turbo 対応の設定
  config.responder.error_status = :unprocessable_content
  config.responder.redirect_status = :see_other

  # Google認証の追加
  config.omniauth :google_oauth2,
                  ENV['GOOGLE_CLIENT_ID'],
                  ENV['GOOGLE_CLIENT_SECRET'],
                  skip_jwt: true

end
