# frozen_string_literal: true

Sentry.init do |config|
  # Renderの環境変数から安全にDSNを取得（設定されていない場合は何もしない）
  config.dsn = ENV["SENTRY_DSN"]

  # Breadcrumbs（パンくず：エラー直前のログやSQLの足跡）を収集
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # 本番環境（production）でのみエラー通知を送信する安全設計
  config.enabled_environments = %w[production]
end
