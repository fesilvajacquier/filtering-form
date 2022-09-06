class MoviesController < ApplicationController
  def index
    @q = Movie.includes(:director).ransack(params[:q])
    @movies = @q.result(distinct: true)
  end

  def filter
    @q = Movie.includes(:director).ransack(params[:q])
    @movies = @q.result(distinct: true)
    render(partial: "movies_list")
  end
end
