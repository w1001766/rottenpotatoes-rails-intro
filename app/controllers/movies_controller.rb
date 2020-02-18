class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    ratings = params[:ratings]

    #filter box session
    if ratings != nil && !ratings.keys.empty?
      session[:filtered_ratings] = ratings
      ratings = ratings.keys
    elsif session[:filtered_ratings] != nil
      redirect = true
    else
      session[:filtered_ratings] = Movie.all_ratings
      ratings = session[:filtered_ratings]
    end
    
    
    # sort session
    sort = params[:sort] != nil ? params[:sort].to_sym : nil
    if sort == :title || sort == :release_date
      session[:sorted] = sort
    elsif session[:sorted] != nil
      redirect = true
    end
    

    
    if redirect == true
      redirect_to movies_path(sort: session[:sorted], ratings: session[:filtered_ratings])
    end
    reset_session 
    
    @checked_ratings = checked_boxes
    @checked_ratings.each do |rating|
      params[rating] = true
    end
    
    if params[:sort]
      @movies = Movie.order(params[:sort])
    else
      @movies = Movie.where(:rating => @checked_ratings)
    end
    
   
  end
private

  def checked_boxes
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq

    if params[:ratings]
      params[:ratings].keys
    else
      @all_ratings
    end
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