require 'rails_helper'

RSpec.describe Record, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }

    context '正常系（合格パターン）' do
      it '18Hの必須情報が揃っていれば登録できること' do
        record = build(:record, user: user)
        expect(record).to be_valid
      end

      it '9H（ハーフ）の必須情報が揃っていれば登録できること' do
        record = build(:record, :half_play, user: user)
        expect(record).to be_valid
      end
    end

    context '基本情報（必須項目）のバリデーション' do
      it 'ゴルフ場名が空の場合は登録できないこと' do
        record = build(:record, user: user, golf_course_name: '')
        expect(record).to be_invalid
        expect(record.errors[:golf_course_name]).to be_present
      end

      it 'プレー日が空の場合は登録できないこと' do
        record = build(:record, user: user, played_on: nil)
        expect(record).to be_invalid
        expect(record.errors[:played_on]).to be_present
      end

      it '総合満足度が空の場合は登録できないこと' do
        record = build(:record, user: user, satisfaction: nil)
        expect(record).to be_invalid
        expect(record.errors[:satisfaction]).to be_present
      end
    end

    context '同一ユーザーの同日・同ゴルフ場重複防止バリデーション' do
      it '同じユーザーが同日・同ゴルフ場で重複登録しようとした場合は登録できないこと' do
        create(:record, user: user, golf_course_name: 'テストカントリークラブ', played_on: Date.current)
        duplicate_record = build(:record, user: user, golf_course_name: 'テストカントリークラブ', played_on: Date.current)
        expect(duplicate_record).to be_invalid
        expect(duplicate_record.errors[:golf_course_name]).to include('は同じ日にすでに登録されています')
      end

      it '別の日付であれば同じゴルフ場名でも登録できること' do
        create(:record, user: user, golf_course_name: 'テストカントリークラブ', played_on: Date.current)
        another_day_record = build(:record, user: user, golf_course_name: 'テストカントリークラブ', played_on: Date.yesterday)
        expect(another_day_record).to be_valid
      end
    end

    context '料金（total_cost）のバリデーション' do
      it 'マイナスの料金は登録できないこと' do
        record = build(:record, user: user, total_cost: -1000)
        expect(record).to be_invalid
        expect(record.errors[:total_cost]).to be_present
      end
    end

    context 'スコア入力のバリデーション' do
      it '18Hスコアと9Hスコアが両方入力されている場合は登録できないこと' do
        record = build(:record, user: user, score_18h: 90, score_9h: 45)
        expect(record).to be_invalid
        expect(record.errors[:base]).to include('スコアは「18Hスコア」または「9Hスコア」のどちらか一方のみ入力してください')
      end
    end

    context '自動計算・換算ロジック' do
      it '9Hスコア入力時に18H換算スコア（2倍）が自動計算されて保存されること' do
        record = create(:record, :half_play, user: user, score_9h: 44)
        expect(record.converted_score_18h).to eq(88)
      end

      it '18Hスコア入力時は換算スコアがnilになること' do
        record = create(:record, user: user, score_18h: 90, score_9h: nil)
        expect(record.converted_score_18h).to be_nil
      end
    end
  end

  describe '検索およびソート用スコープのテスト' do
    let(:user) { create(:user) }

    describe '.search_by_keyword' do
      let!(:record1) { create(:record, user: user, golf_course_name: '富士カントリークラブ', companion: '友人', memo: '楽しかった', played_on: Date.new(2026, 5, 1)) }
      let!(:record2) { create(:record, user: user, golf_course_name: '箱根ゴルフ場', companion: '上司', memo: '富士山が見えた', played_on: Date.new(2026, 5, 2)) }
      let!(:record3) { create(:record, user: user, golf_course_name: '軽井沢高原ゴルフ', companion: 'ソロ', memo: '避暑地ラウンド', played_on: Date.new(2026, 5, 3)) }

      it 'ゴルフ場名で部分一致検索できること' do
        expect(described_class.search_by_keyword('富士')).to contain_exactly(record1, record2)
      end

      it '同伴者名で部分一致検索できること' do
        expect(described_class.search_by_keyword('上司')).to contain_exactly(record2)
      end

      it 'メモの内容で部分一致検索できること' do
        expect(described_class.search_by_keyword('避暑地')).to contain_exactly(record3)
      end

      it 'キーワードが空（nilまたは空文字）の場合は全件返すこと' do
        expect(described_class.search_by_keyword('')).to contain_exactly(record1, record2, record3)
        expect(described_class.search_by_keyword(nil)).to contain_exactly(record1, record2, record3)
      end
    end

    describe '.sorted_by' do
      let!(:record_old_low) do
        create(:record, user: user, golf_course_name: 'コースA', played_on: Date.new(2026, 1, 1),
                        satisfaction: :star1, score_18h: 110, total_cost: 15_000)
      end
      let!(:record_new_high) do
        create(:record, user: user, golf_course_name: 'コースB', played_on: Date.new(2026, 3, 1),
                        satisfaction: :star5, score_18h: 88, total_cost: 9_000)
      end
      let!(:record_no_score_cost) do
        create(:record, user: user, golf_course_name: 'コースC', played_on: Date.new(2026, 2, 1),
                        satisfaction: :star3, score_18h: nil, converted_score_18h: nil, total_cost: nil)
      end

      it 'played_on_asc でプレー日が古い順に並び替わること' do
        expect(described_class.sorted_by('played_on_asc')).to eq([ record_old_low, record_no_score_cost, record_new_high ])
      end

      it 'satisfaction_desc で満足度が高い順に並び替わること' do
        expect(described_class.sorted_by('satisfaction_desc')).to eq([ record_new_high, record_no_score_cost, record_old_low ])
      end

      it 'score_asc でスコアが良い順に並び、未入力レコードは除外されること' do
        results = described_class.sorted_by('score_asc')
        expect(results).to eq([ record_new_high, record_old_low ])
        expect(results).not_to include(record_no_score_cost)
      end

      it 'cost_asc で料金が安い順に並び、未入力レコードは除外されること' do
        results = described_class.sorted_by('cost_asc')
        expect(results).to eq([ record_new_high, record_old_low ])
        expect(results).not_to include(record_no_score_cost)
      end

      it 'cost_desc で料金が高い順に並び、未入力レコードは除外されること' do
        results = described_class.sorted_by('cost_desc')
        expect(results).to eq([ record_old_low, record_new_high ])
        expect(results).not_to include(record_no_score_cost)
      end

      it '指定なし（デフォルト）でプレー日が新しい順に全件並び替わること' do
        expect(described_class.sorted_by(nil)).to eq([ record_new_high, record_no_score_cost, record_old_low ])
      end
    end
  end
end
