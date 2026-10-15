class RecordsController < ApplicationController
  # 未ログインユーザーをログイン画面へリダイレクト
  before_action :authenticate_user!
  # 指定アクションの実行前に対象のカルテを取得して @record にセット
  before_action :set_record, only: %i[show edit update destroy]

  # カルテ一覧表示（キーワード検索およびソートを適用）
  def index
    @records = current_user.records
                           .includes(:images_attachments)
                           .search_by_keyword(params[:keyword])
                           .sorted_by(params[:sort])
  end

  # カルテ詳細表示（set_record で取得した @record を表示）
  def show; end

  # カルテ新規作成フォーム表示
  def new
    @record = Record.new
  end

  # カルテ編集フォーム表示（set_record で取得した @record を表示）
  def edit; end

  # カルテ新規登録処理
  def create
    @record = current_user.records.build(record_params)

    if @record.save
      redirect_to record_path(@record), notice: "ゴルフカルテを作成しました"
    else
      flash.now[:alert] = "カルテの作成に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  # カルテ更新処理
  def update
    if @record.update(record_params)
      redirect_to record_path(@record), notice: "ゴルフカルテを更新しました"
    else
      flash.now[:alert] = "カルテの更新に失敗しました。入力内容を確認してください。"
      render :edit, status: :unprocessable_entity
    end
  end

  # カルテ削除処理
  def destroy
    @record.destroy
    redirect_to records_path, notice: "ゴルフカルテを削除しました", status: :see_other
  end

  private

  # 他ユーザーのカルテへの不正アクセスを防ぐため current_user 経由で取得
  def set_record
    @record = current_user.records.find(params[:id])
  end

  # 許可されたパラメータのみを受け取るストロングパラメータ
  def record_params
    params.require(:record).permit(
      :golf_course_name,
      :played_on,
      :satisfaction,
      :companion,
      :score_18h,
      :score_9h,
      :tee,
      :weather,
      :pace,
      :play_style,
      :brand,
      :difficulty,
      :course_width,
      :fairway,
      :green_memo,
      :ob_risk,
      :bunker_difficulty,
      :hazard,
      :toilet_rating,
      :bath_rating,
      :bath_memo,
      :shop_memo,
      :cart_type,
      :maintenance,
      :service,
      :food_rating,
      :food_memo,
      :total_cost,
      :cost_memo,
      :memo,
      green_features: [],
      driving_range: [],
      bath_features: [],
      plan_options: [],
      images: []
    )
  end
end
