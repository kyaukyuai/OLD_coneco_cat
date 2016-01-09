class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      @graph = Koala::Facebook::API.new(current_user.oauth_token)
      @profile = @graph.get_object("me")
      @cats = InstagramCat.all.page(1)
      p @cats
    end
  end

  def show
  end
end
