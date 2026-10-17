require "active_support/core_ext/integer/time"

Rails.application.configure do
  # config/application.rb の設定より、このファイルの設定が優先

  # ----------------------------------------------------
  # コード読み込み・エラー表示設定
  # ----------------------------------------------------
  # リクエストごとのコード再読み込みを無効化（本番パフォーマンス向上）
  config.enable_reloading = false

  # 起動時にコードを一括事前読み込み（メモリ節約・実行速度向上）
  config.eager_load = true

  # 詳細なエラー画面を表示しない（セキュリティ対策）
  config.consider_all_requests_local = false

  # ビューテンプレートのフラグメントキャッシュを有効化
  config.action_controller.perform_caching = true

  # 静的アセット（CSS/JS等）のブラウザキャッシュ期間を1年に設定（ダイジェスト付きアセット用）
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # ファイルアップロードの保存先（本番環境はAWS S3）
  config.active_storage.service = :amazon

  # ----------------------------------------------------
  # SSL / セキュリティ設定
  # ----------------------------------------------------
  # SSL終端リバースプロキシ経由のアクセスを前提にする（Render等のPaaS環境用）
  config.assume_ssl = true

  # すべての通信をHTTPSに強制（HSTS・セキュアクッキー適用）
  config.force_ssl = true

  # ----------------------------------------------------
  # ログ設定
  # ----------------------------------------------------
  # リクエストIDをログのタグとして付与
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # ログレベルの設定（環境変数 RAILS_LOG_LEVEL がなければ info）
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # ヘルスチェック（/up）のログ出力を抑制してログの圧迫を防止
  config.silence_healthcheck_path = "/up"

  # 非推奨警告（Deprecation）のログ出力を無効化
  config.active_support.report_deprecations = false

  # ----------------------------------------------------
  # キャッシュ・バックグラウンドジョブ設定（Rails 8標準）
  # ----------------------------------------------------
  # キャッシュストアに Solid Cache を使用
  config.cache_store = :solid_cache_store

  # Active Job のキューアダプタを async（非同期・メモリ処理）に変更
  config.active_job.queue_adapter = :async
  # config.solid_queue.connects_to = { database: { writing: :queue } }

# ----------------------------------------------------
  # メール送信設定（Action Mailer - Resend設定）
  # ----------------------------------------------------
  config.action_mailer.default_url_options = { host: ENV.fetch("APP_HOST", "gollog.onrender.com"), protocol: "https" }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp

  # Resend用のSMTP設定
  config.action_mailer.smtp_settings = {
    address:              ENV.fetch("SMTP_ADDRESS", "smtp.resend.com"),
    port:                 ENV.fetch("SMTP_PORT", 587).to_i,
    domain:               ENV.fetch("SMTP_DOMAIN", "resend.com"),
    user_name:            "resend",               # ResendのSMTPユーザー名は固定で "resend"
    password:             ENV["RESEND_API_KEY"],  # Resendで取得したAPIキー
    authentication:       :plain,
    enable_starttls_auto: true
  }

  # ----------------------------------------------------
  # 国際化（I18n）＆ データベース設定
  # ----------------------------------------------------
  # 翻訳が見つからない場合のフォールバックを有効化
  config.i18n.fallbacks = true

  # マイグレーション実行後に schema.rb をダンプしない（本番実行の高速化）
  config.active_record.dump_schema_after_migration = false

  # 本番でのモデル詳細出力（inspect）を :id のみに制限（個人情報・秘密情報の保護）
  config.active_record.attributes_for_inspect = [ :id ]
end
