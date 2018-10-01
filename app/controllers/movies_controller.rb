class MoviesController < ApplicationController

  TITLE = 'title'
  RELEASE_DATE = 'release_date'

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.has_key?(:sortBy) && params.has_key?(:ratings)
      @sortBy = params[:sortBy]
      @selected_ratings = params[:ratings]
      session[:sortBy] = @sortBy
      session[:ratings] = @selected_ratings
      redirect = false
    elsif params.has_key?(:sortBy)
      @sortBy = params[:sortBy]
      @selected_ratings = session[:ratings]
      session[:sortBy] = @sortBy
      redirect = false
    elsif params.has_key?(:ratings)
      @selected_ratings = params[:ratings]
      @sortBy = session[:sortBy]
      session[:ratings] = @selected_ratings
      redirect = false
    else
      @sortBy = session[:sortBy]
      @selected_ratings = session[:ratings]
      redirect = true
    end
    
    @all_ratings = Movie.ratings

    if @sortBy == TITLE || RELEASE_DATE
      if @selected_ratings.nil?
        @movies = Movie.order(@sortBy)
      else
        @movies = Movie.where(:rating => @selected_ratings.keys).order("#{@sortBy}")
      end
    else
      @movies = Movies.where(:rating => @selected_ratings.keys)
    end
    
    if redirect
      flash.keep
      redirect_to :sortBy => @sortBy, :ratings => @selected_ratings and return
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
