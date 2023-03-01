class LikesController < ApplicationController
  def index
    matching_likes = Like.all

    @list_of_likes = matching_likes.order({ :created_at => :desc })

    render({ :template => "likes/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_likes = Like.where({ :id => the_id })

    @the_like = matching_likes.at(0)

    render({ :template => "likes/show.html.erb" })
  end

  def create
    the_like = Like.new
    the_like.photo_id = params.fetch("query_photo_id")
    the_like.fan_id = session[:user_id]

    the_like.photo.likes_count = the_like.photo.likes.count + 1
    the_like.fan.likes_count = the_like.fan.likes.count + 1
    # the_photo = Photo.where({:id => params.fetch("query_photo_id")}).at(0)
    # the_photo.likes_count = the_photo.likes_count + 1

    if the_like.valid?
      the_like.save
      the_like.photo.save
      the_like.fan.save
      redirect_to(request.referer, { :notice => "Like created successfully." })
    else
      redirect_to(request.referer, { :alert => the_like.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_like = Like.where({ :id => the_id }).at(0)

    the_like.photo_id = params.fetch("query_photo_id")
    the_like.fan_id = session[:user_id]

    if the_like.valid?
      the_like.save
      redirect_to("/likes/#{the_like.id}", { :notice => "Like updated successfully."} )
    else
      redirect_to("/likes/#{the_like.id}", { :alert => the_like.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_like = Like.where({ :id => the_id }).at(0)

    the_like.photo.likes_count = the_like.photo.likes.count - 1
    the_like.fan.likes_count = the_like.fan.likes.count - 1
    # the_photo = the_like.photo
    # the_photo.likes_count = the_photo.likes_count - 1

    the_like.photo.save
    the_like.fan.save
    the_like.destroy

    redirect_to(request.referer, { :notice => "Like deleted successfully."} )
  end
end
