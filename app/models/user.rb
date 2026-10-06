class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :records, dependent: :destroy

  # ゲストユーザー取得・作成メソッド
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64(16)
      user.name = "ゲストゴルファー"
    end.tap do |user|
      # ゲストのカルテが0件の場合のみ、初期サンプルデータを自動作成する
      user.create_sample_records if user.records.empty?
    end
  end

  # 架空コースのサンプルカルテ5件（フォームの選択肢・配列定義に完全準拠）
  def create_sample_records
    records.create!([
      # 1. 【全項目網羅】フルスペックカルテ
      {
        golf_course_name: "エメラルドグリーンカントリー倶楽部",
        played_on: Date.current - 7.days,
        satisfaction: :star5,
        score_18h: 88,
        score_9h: nil,
        tee: "レギュラー",
        companion: "職場のゴルフ仲間",
        weather: "晴れ",
        pace: "スムーズ・空いていた",
        play_style: "通常(ハーフ休憩あり)",
        brand: "その他・単体",
        difficulty: "普通",
        course_width: "広い（フェアウェイ乗せやすい）",
        fairway: "適度な起伏(普通)",
        ob_risk: "出にくい(安心)",
        bunker_difficulty: "普通",
        hazard: "適度にある",
        green_features: [ "グリーン速い", "傾斜・2段グリーン強め" ],
        green_memo: "下りのパットがかなり転がるので手前から攻めるのが鉄則。",
        cart_type: "リモコン電磁誘導",
        toilet_rating: "多い",
        maintenance: "素晴らしい",
        service: "丁寧で心地よい",
        driving_range: [ "打ちっぱなし", "アプローチ練習場", "バンカー練習場" ],
        shop_memo: "売店は電子マネー完全対応。茶屋も営業していて便利。",
        bath_rating: "大満足",
        bath_features: [ "温泉あり", "サウナあり", "高級ドライヤー(ReFa等)あり", "アメニティ充実" ],
        bath_memo: "露天風呂からの景色が最高。サウナと水風呂で疲れが完全にリセットできた。",
        total_cost: 16800,
        cost_memo: "平日WEB優待プラン・昼食付き",
        plan_options: [ "昼食付", "クールカート" ],
        food_rating: "とても美味しい",
        food_memo: "名物の黒毛和牛ハンバーグ御膳が絶品！お米も炊き立てで美味しかった。",
        memo: "天候にも恵まれ、全員がベストスコアに近い数字を出せて大満足のラウンド。グリーンが速くて面白いのでまたリピートしたい！"
      },

      # 2. 【必須項目のみ】ミニマム記録
      {
        golf_course_name: "サンシャインヒルズゴルフコース",
        played_on: Date.current - 18.days,
        satisfaction: :star3,
        score_18h: nil,
        score_9h: nil,
        green_features: [],
        driving_range: [],
        bath_features: [],
        plan_options: [],
        memo: "仕事帰りの急なコンペ参加。スコアは数えずエンジョイ優先でラウンド！"
      },

      # 3. 【9Hハーフプレー】夕方薄暮ラウンド（換算スコア自動計算の確認用）
      {
        golf_course_name: "サクラリバーサイドゴルフリンクス",
        played_on: Date.current - 28.days,
        satisfaction: :star4,
        score_18h: nil,
        score_9h: 44,
        tee: "フロント",
        companion: "一人予約",
        weather: "くもり",
        pace: "スムーズ・空いていた",
        play_style: "薄暮ハーフ",
        brand: "市営・パブリック",
        difficulty: "易しい",
        course_width: "広い（フェアウェイ乗せやすい）",
        fairway: "フラット(平坦)",
        ob_risk: "出にくい(安心)",
        bunker_difficulty: "少ない・浅い",
        hazard: "ほぼなし",
        green_features: [ "グリーン遅い", "広くて乗りやすい" ],
        green_memo: "芝目に逆らうとしっかりショートする。カップの奥を強めに狙うと良い。",
        cart_type: "手引き・歩き",
        toilet_rating: "普通",
        maintenance: "普通",
        service: "普通",
        driving_range: [ "パター練習のみ" ],
        bath_rating: "普通",
        bath_features: [ "シャワーのみ" ],
        bath_memo: "薄暮プランのためシャワーのみ利用可能。",
        total_cost: 5500,
        cost_memo: "薄暮ハーフセルフ料金",
        plan_options: [ "手引き・歩き" ],
        food_rating: nil,
        memo: "夕方の薄暮9Hハーフ。河川敷コースでフラット。歩きプレーでとても良い運動になった。"
      },

      # 4. 【戦略重視・難コース】本音の注意点メモ充実
      {
        golf_course_name: "フォレストウッドゴルフ倶楽部",
        played_on: Date.current - 45.days,
        satisfaction: :star4,
        score_18h: 104,
        score_9h: nil,
        tee: "バック",
        companion: "ゴルフ仲間（月例杯）",
        weather: "強風",
        pace: "待ち多め・混雑",
        play_style: "コンペ",
        brand: "PGM",
        difficulty: "難しい・戦略的",
        course_width: "狭い（プレッシャーあり）",
        fairway: "アンジュレーション強め",
        ob_risk: "出やすい(狭い)",
        bunker_difficulty: "アゴが高い(脱出難)",
        hazard: "池・谷越え多め",
        green_features: [ "砲台グリーン多め", "狭くて乗せにくい" ],
        green_memo: "砲台グリーンが多く、グリーン手前に落とすと転がり落ちる。手前からの寄せワン狙いが必須。",
        cart_type: "自走カート",
        toilet_rating: "普通",
        maintenance: "良い",
        service: "良い",
        driving_range: [ "打ちっぱなし", "バンカー練習場" ],
        shop_memo: "ボールをなくしやすいコースなので売店でロストボールの補充推奨。",
        bath_rating: "満足",
        bath_features: [ "サウナあり" ],
        bath_memo: "サウナでじっくり温まれる。脱衣所も清潔。",
        total_cost: 14500,
        cost_memo: "コンペ参加費込み",
        plan_options: [ "昼食付", "キャディ付" ],
        food_rating: "美味しい",
        food_memo: "担々麺が本格的で温まった。",
        memo: "トリッキーで非常に戦略的なコース。ドライバーを封印してアイアンで刻む勇気が必要だった。次回はマネジメントを徹底してリベンジする！"
      },

      # 5. 【施設・食事特化】リゾート＆温泉重視
      {
        golf_course_name: "レイクビューゴルフ＆リゾート",
        played_on: Date.current - 60.days,
        satisfaction: :star5,
        score_18h: 96,
        score_9h: nil,
        tee: "レギュラー",
        companion: "家族ラウンド",
        weather: "晴れ",
        pace: "普通",
        play_style: "スループレー",
        brand: "東急リゾート",
        difficulty: "普通",
        course_width: "やや広い",
        fairway: "適度な起伏(普通)",
        ob_risk: "普通",
        bunker_difficulty: "普通",
        hazard: "適度にある",
        green_features: [ "広くて乗りやすい" ],
        green_memo: "素直な転がりで癖がない。ピン位置に素直に打てる。",
        cart_type: "フェアウェイ乗り入れ可",
        toilet_rating: "多い",
        maintenance: "素晴らしい",
        service: "丁寧で心地よい",
        driving_range: [ "打ちっぱなし", "アプローチ練習場" ],
        shop_memo: "地元特産のスイーツやお土産コーナーが充実。",
        bath_rating: "大満足",
        bath_features: [ "温泉あり", "露天風呂あり", "アメニティ充実" ],
        bath_memo: "天然温泉のとろりとしたお湯で最高にリフレッシュできる。パウダールームも広くて綺麗。",
        total_cost: 18000,
        cost_memo: "カート乗り入れ追加料金込み",
        plan_options: [ "昼食付", "乗り入れ可" ],
        food_rating: "とても美味しい",
        food_memo: "海鮮ちらし重が新鮮でボリューム満点だった！",
        memo: "クラブハウスが清潔でリゾート気分を満喫できた。カート乗り入れが楽ちんで初心者や女性同伴でも安心して楽しめるおすすめコース。"
      }
    ])
  end
end
