class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[top terms privacy], raise: false

  def top; end

  def terms; end

  def privacy; end
end
