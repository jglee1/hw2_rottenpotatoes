class MoviesController < ApplicationController

  helper_method :sortBy, :filtered_rating

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.rating_list
    @ratings = @all_ratings
    if params[:ratings] then
      @ratings = params[:ratings].select { |k,v| v=="1"}.keys
    end
    @movies = Movie.scoped
    @movies = @movies.where("rating IN (?)", @ratings)
    @movies = @movies.order('title') if params['sort'] == 'title'
    @movies = @movies.order('release_date') if params['sort'] == 'release_date'

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def sortBy
    params[:sort]
  end
  def filteredRating
    rating_list =[]
    rating_list = params[:rating].select {|k,v| v=="1"}.keys
    return rating_list
  end

end
