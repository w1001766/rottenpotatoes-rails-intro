class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    redirect_sort = false
    redirect_filter = false
    ratings = params[:ratings]
    sort = params[:sort] != nil ? params[:sort].to_sym : nil

    ##########Begin part 3#####
    
    #sort session
    if sort == :title || sort == :release_date
      session.clear
      session[:sorted] = sort
    elsif session[:sorted] != nil
      redirect = true
      redirect_sort = true

    else
      redirect = false
    end
    
     #rating session
    if ratings != nil && !ratings.keys.empty?
      session.clear
      session[:rating] = ratings
      ratings = ratings.keys
    
  
    elsif session[:rating] != nil
       redirect = true
    else
      redirect = false
    end
    
    

    if redirect == true
      redirect_to movies_path(sort: session[:sorted], ratings: session[:rating])
    end
    
    ##########End part3############
    
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