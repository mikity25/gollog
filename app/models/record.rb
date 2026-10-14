class Record < ApplicationRecord
  # アソシエーション
  belongs_to :user

  # 複数選択肢（チェックボックス配列）をYAML形式で文字列カラムに自動シリアライズ
  serialize :green_features, type: Array, coder: YAML
  serialize :driving_range, type: Array, coder: YAML
  serialize :bath_features, type: Array, coder: YAML
  serialize :plan_options, type: Array, coder: YAML

  # 総合満足度（星1〜星5）
  enum :satisfaction, { star1: 1, star2: 2, star3: 3, star4: 4, star5: 5 }

  # 必須項目バリデーション
  validates :golf_course_name, presence: true
  validates :played_on, presence: true
  validates :satisfaction, presence: true

  # 同一ユーザーによる「同日・同ゴルフ場」の二重登録防止
  validates :golf_course_name, uniqueness: {
    scope: [ :user_id, :played_on ],
    message: "は同じ日にすでに登録されています"
  }

  # 総額料金：0以上の整数のみ許可（未入力OK）
  validates :total_cost, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    allow_nil: true
  }

  # カスタムバリデーション：18Hと9Hの同時入力を禁止
  validate :either_score_18h_or_score_9h

  # コールバック：保存前に9Hスコアから18H換算目安を自動計算
  before_save :calculate_converted_score_18h

  # ==================== スコープ（検索・ソート） ====================
  # ゴルフ場名・同伴者・メモのキーワードあいまい検索
  scope :search_by_keyword, ->(keyword) {
    if keyword.present?
      sanitized_keyword = "%#{sanitize_sql_like(keyword)}%"
      where("golf_course_name ILIKE :kw OR companion ILIKE :kw OR memo ILIKE :kw", kw: sanitized_keyword)
    end
  }

  # 並び替え（ソート）
  scope :sorted_by, ->(sort_key) {
    case sort_key
    when "played_on_asc"
      order(played_on: :asc, created_at: :asc)
    when "satisfaction_desc"
      order(satisfaction: :desc, played_on: :desc)
    when "satisfaction_asc"
      order(satisfaction: :asc, played_on: :desc)
    when "score_asc"
      # スコアが入力されているものだけに絞り込み、打数が少ない順に並べる
      where.not(score_18h: nil).or(where.not(converted_score_18h: nil))
        .order(Arel.sql("COALESCE(score_18h, converted_score_18h) ASC, played_on DESC"))
    when "cost_asc"
      # 料金が入力されているものだけに絞り込み、安い順に並べる
      where.not(total_cost: nil).order(total_cost: :asc, played_on: :desc)
    when "cost_desc"
      # 料金が入力されているものだけに絞り込み、高い順に並べる
      where.not(total_cost: nil).order(total_cost: :desc, played_on: :desc)
    else
      # デフォルト：プレー日が新しい順（全件表示）
      order(played_on: :desc, created_at: :desc)
    end
  }

  private

  # スコア排他制御
  def either_score_18h_or_score_9h
    return unless score_18h.present? && score_9h.present?

    errors.add(:base, "スコアは「18Hスコア」または「9Hスコア」のどちらか一方のみ入力してください")
  end

  # ハーフ(9H)スコア入力時は2倍した値をセット、未入力時はnil
  def calculate_converted_score_18h
    self.converted_score_18h = score_9h.present? ? score_9h * 2 : nil
  end
end
