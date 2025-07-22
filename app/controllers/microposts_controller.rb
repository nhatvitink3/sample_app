class MicropostsController < ApplicationController
  def index
    @microposts = Micropost.newest
  end
end
