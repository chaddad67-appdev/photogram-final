class UsersController < ApplicationController
  # Uncomment line 3 in this file and line 5 in ApplicationController if you want to force users to sign in before any other actions.
  # skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

  def index
    @users = User.all.order({:username => :asc })
    render({ :template => "users/index.html.erb" })
  end

  def show
    @user = User.where({:username => params.fetch("username")}).at(0)
    follow_req  = FollowRequest.where({ :sender_id => session[:user_id], :recipient_id => @user.id }).at(0)
    if @user.private == false || @user.id == session[:user_id] || follow_req != nil
      if @user.private == false || @user.id == session[:user_id] || follow_req.status == "accepted"
        render({ :template => "users/show.html.erb" })
      else
        redirect_to("/", { :alert => "You're not authorized for that." })
      end
    else 
      redirect_to("/", { :alert => "You're not authorized for that." })
    end
  end

  def sign_in_form
    render({ :template => "users/sign_in.html.erb" })
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id
        session[:user_name] = user.username
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def sign_up_form
    render({ :template => "users/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.comments_count = 0
    @user.likes_count = 0
    @user.username = params.fetch("query_username")
    @user.private = params.fetch("query_private", false)

    save_status = @user.save

    if save_status == true
      session[:user_id] = @user.id
      session[:user_name] = @user.username

      redirect_to("/", { :notice => "User account created successfully."})
    else
      redirect_to("/user_sign_up", { :alert => @user.errors.full_messages.to_sentence })
    end
  end
    
  def edit_profile_form
    render({ :template => "users/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.comments_count = params.fetch("query_comments_count")
    @user.likes_count = params.fetch("query_likes_count")
    @user.username = params.fetch("query_username")
    @user.private = params.fetch("query_private", false)
    
    if @user.valid?
      @user.save

      redirect_to("users/edit_profile.html.erb", { :notice => "User account updated successfully."})
    else
      render({ :template => "users/edit_profile_with_errors.html.erb" , :alert => @user.errors.full_messages.to_sentence })
    end
  end

  def update_name
    @user = @current_user
    @user.username = params.fetch("query_username")
    @user.private = params.fetch("query_private", false)
    
    if @user.valid?
      @user.save

      redirect_to("/users/#{@user.username}", { :notice => "User account updated successfully."})
    else
      redirect_to("/users/#{@user.username}", {:alert => @user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled" })
  end
 
end
