Rails.application.routes.draw do
  # Deviseのルーティング（ログイン・新規登録など）
  devise_for :users, controllers: {
  registrations: "users/registrations"
  }

  # ゲストログイン用
  post "guest_sign_in", to: "users/guest_sessions#create"

  # アプリのルートURL（ / ）にアクセスした際、StaticPagesController の top アクションを表示する
  root "static_pages#top"

  # 静的ページ
  get "terms", to: "static_pages#terms"
  get "privacy", to: "static_pages#privacy"

  # カルテの一覧・作成画面・保存処理の道を開通
  resources :records, only: [ :index, :new, :create, :show, :edit, :update, :destroy ]

  # ヘルスチェック用（Rails8標準設定）
  get "up" => "rails/health#show", as: :rails_health_check

  # 開発環境用のメール受信確認画面（Letter Opener）
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # ゴルフ場オートコンプリート検索用エンドポイント
  resources :golf_courses, only: [] do
    collection do
      get :search
    end
  end
end
