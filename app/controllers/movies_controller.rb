class MoviesController < ApplicationController

  helper_method :sortBy, :filtered_rating

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering, @title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering, @date_header = {:order => :release_date}, 'hilite'
    end

    @all_ratings = Movie.all_rating_list
    @rating_list = params[:ratings] || session[:ratings] || {}

    if @rating_list == {}
      @rating_list = Hash[@all_ratings.map{ |rating| [rating,rating] }]
    end

    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @rating_list
      redirect_to :sort => sort, :ratings => @rating_list and return
    end
    @movies = Movie.find_all_by_rating(@rating_list.keys, ordering)
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
    @rating_list =[]
    @rating_list = params[:rating].select {|k,v| v=="1"}.keys
    return @rating_list
  end

end
