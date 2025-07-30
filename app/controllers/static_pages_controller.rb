class StaticPagesController < ApplicationController
  # GET /(root_path)
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed, items: Settings.page_10
  end

  # GET /help
  def help; end

  # GET /contact
  def contact; end
end
