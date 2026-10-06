class Users::GuestSessionsController < ApplicationController
  def create
    user = User.guest
    sign_in user
    redirect_to records_path, notice: "ゲストゴルファーとしてログインしました！カルテの閲覧や作成をお試しいただけます。"
  end
end
