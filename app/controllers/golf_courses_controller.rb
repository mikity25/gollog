# frozen_string_literal: true

class GolfCoursesController < ApplicationController
  # ログイン必須アプリの場合でも、検索自体は認証不要にするか要確認
  # 必要に応じて skip_before_action :authenticate_user!, only: [:search] などを設定

  def search
    keyword = params[:keyword]
    golf_courses = RakutenGoraService.new(keyword).search_golf_courses

    render json: golf_courses
  end
end
