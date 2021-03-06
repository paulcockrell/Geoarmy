class LoginController < ApplicationController
before_filter :set_active_menu, :only => [:add_user]
before_filter :authorize, :except => [:login, :add_user, :get_auth_token]
protect_from_forgery :except => [:get_auth_token]
before_filter :prepare_for_mobile

  def login
    @sent_token = params[:authenticity_token]
    @real_token = form_authenticity_token
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      uri = session[:original_uri]
      session[:original_uri] = nil      

      if user
        session[:user_id] = user.id
        flash[:notice] = "You are now logged in"
        flash[:login] = "true"
      else
        flash[:notice] = "Invalid user/password combination"
      end
      respond_to do |format|
        format.html {logger.info "bolox"; redirect_to(uri || {:controller=>"home",:action=>"index"}) }
        format.mobile { render :partial => "/home/index.mobile", :locals => {:user => user, :sent_token => @sent_token, :real_token => @real_token} }
      end
    end
  end

  def get_auth_token
     @token = form_authenticity_token
     respond_to do |format|
         format.mobile { render :html => @token }
         format.html  { render :html => @token }
     end
  end

  def logout
      session[:user_id] = nil
      flash[:notice] = "You are now logged out"
      flash[:logout] = "true"
      redirect_to(:controller=>"home", :action => "index")
  end

  def index
  end

  def delete_user
      if request.post?
          user = User.find(params[:id])
          user.destroy
      end
      redirect_to(:action => :list_users)
  end
  
  def list_users
      @all_users = User.find(:all)
  end

  private

  def set_active_menu
      session[:active_menu] = "item30"
  end
end
