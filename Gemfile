source "https://rubygems.org"

# Rails本体
gem "rails", "~> 8.1.3", ">= 8.1.3.1"

# アセット管理（JavaScript / CSS / 画像など）
gem "propshaft"

# データベース（PostgreSQL）用接続ライブラリ
gem "pg", "~> 1.7"

# Webサーバー（Puma）
gem "puma", ">= 5.0"

# JavaScriptおよびCSSのビルドツール
gem "jsbundling-rails"
gem "cssbundling-rails"

# 画面遷移の高速化・非同期処理（Hotwire）
gem "turbo-rails"
gem "stimulus-rails"

# JSONデータの生成ツール
gem "jbuilder"

# ユーザー認証・ログイン機能（Devise）と暗号化（bcrypt）
gem "bcrypt", "~> 3.1.7"
gem "devise"

# Windows環境用のタイムゾーンデータ
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Rails標準のキャッシュ・非同期処理・リアルタイム通信用機能
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# 起動時間の短縮用キャッシュ機能
gem "bootsnap", require: false

# アセットのキャッシュ圧縮および転送高速化
gem "thruster", require: false

# 画像処理（Active Storage用）
gem "image_processing", "~> 1.2"

# 開発環境およびテスト環境でのみ使用するGem
group :development, :test do
  # デバッグツール
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # セキュリティ脆弱性の自動チェックツール
  gem "bundler-audit", require: false
  gem "brakeman", require: false

  # コード書き方のルールチェックツール（RuboCop）
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rails", require: false

  # 自動テスト用ツール（RSpec / FactoryBot）
  gem "rspec-rails"
  gem "factory_bot_rails"

  # N+1問題を検知・警告するツール
  gem "bullet"
end

# 開発環境でのみ使用するGem
group :development do
  # エラー画面上で直接コードを実行して調べるデバッグツール
  gem "web-console"

  # 開発環境でのメール受信プレビュー確認ツール
  gem "letter_opener_web", "~> 3.0"
end

# テスト環境でのみ使用するGem
group :test do
  # ブラウザ動作確認用のテストツール
  gem "capybara"
  gem "selenium-webdriver"
  # テスト後のゴミ掃除（DB初期化）
  gem "database_cleaner-active_record"
  # テストカバレッジ測定ツール
  gem "simplecov", require: false
end

# 本番エラー監視ツール（Sentry）
gem "sentry-ruby"
gem "sentry-rails"
