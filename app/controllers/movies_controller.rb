class MoviesController < ApplicationController

  @@sort_var = 0

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      #sort_var = params[:sort_var].to_i
      #@@sort_var = (@@sort_var - sort_var).abs
      #if @@sort_var == 0
        ordering, @title_header = {:order => 'title ASC'}, 'hilite'
      #else
      #  ordering, @title_header = {:order => 'title DESC'}, 'hilite'
      #end
    when 'release_date'
      #if @date_header == nil
        ordering, @date_header = {:order => 'release_date ASC'}, 'hilite'
      #else
      #  ordering, @date_header = {:order => 'release_date DESC'}, 'hilite'
      #end
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    #fills the ratings initially when webpage is loaded
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
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

end
