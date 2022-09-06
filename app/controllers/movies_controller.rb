class MoviesController < ApplicationController
  def index
    @q = Movie.includes(:director).ransack(params[:q])
    @movies = @q.result(distinct: true)
  end
end
