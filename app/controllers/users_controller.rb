class UsersController < ApplicationController
before_filter :find_user,
    :only => [:show, :edit, :update]
before_filter :authorize,
    :only => [:edit, :update, :show]
before_filter :set_menu

  def index
      @current_user = get_user
  end

   # GET /profile/1                                                                               
   # GET /profile/1.xml
   def show
       logger.warn params[:id]
       params[:id].nil? ? (@user = get_user) : (@user = User.find_by_id(params[:id]))
       @connection         = get_user.connections.find(:all, :conditions=>['connection_id=?',params[:id]])
       @title = "#{@user.name}'s profile" unless params[:id].nil?
       respond_to do |format|
         format.html # show.html.erb
         format.xml  { render :xml => @user }
       end
   rescue ActiveRecord::RecordNotFound
        logger.error("Attempt to access an unknown users profile")
        flash[:notice] = "An error occured, please try again"
        redirect_to(:controller=>'profile', :action=>'show')
   end
 
   # GET /profile/edit
   def edit
       @user = get_user
   end
 
  def create
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash.now[:notice] = "User #{@user.name} created"
      @user = User.new
    else
      flash.now[:notice] = @user.errors.full_messages.to_sentence
    end
  end
 
   # PUT /profile/
   # PUT /profile/1.xml
   def update
     respond_to do |format|
       if @user.update_attributes(params[:user])
         format.html { redirect_to(@user, :notice => 'Your profile was successfully updated.') }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
       end
     end
   end

   def forgotten_username
     if get_user.nil?
       if request.post?
         user = find_user_by_email(params[:email])
         unless user.nil?
           email = ReminderMailer.create_username(user)
           email.set_content_type("text/plain")
           ReminderMailer.deliver(email)
           flash.now[:notice] = "An email has been sent to your email address confirming your username"
         else
           flash.now[:notice] = "That email address has not been found in our records"
         end
       end
     else
       flash[:notice] = "You are logged in, you must know your user name"
       redirect_to :controller => 'home'
     end
   end

   def forgotten_password
     if get_user.nil?
       if request.post?
         user = find_user_by_email(params[:email])
         unless user.nil?
           key = User.generate_reminder_key(user)
           user.update_attribute(:key, key)
           email = ReminderMailer.create_password(user)
           email.set_content_type("text/plain")
           ReminderMailer.deliver(email)
           flash.now[:notice] = "An email has been sent to your email address containing a link to reset your password"
         else
           flash.now[:notice] = "That email address has not been found in our records"
         end
      end
    else
      flash[:notice] = "You are logged in, you must know your password"
      redirect_to :controller => 'home'
    end
   end

   def reset_password
     @user = User.find_by_key(params[:id]) || User.find_by_key(params[:user][:key])
     unless @user.nil?
       if request.post?
         params[:user][:key] = nil
         if @user.update_attributes(params[:user])
           flash[:notice] = "Password successfully updated"
           redirect_to :controller => 'home'
         else
           flash.now[:notice] = "Failed to update password, make sure they match and try again"
         end
       end
     else
       flash[:notice] = "Invalid reset key"
       redirect_to :controller => 'home'
     end
   rescue
     flash[:notice] = "Invalid reset key"
     redirect_to :controller => 'home'
   end
   
   private

   def find_user
       @user = User.find_by_id(session[:user_id])
   end

   def find_user_by_email(email)
       @user = User.find_by_email(email)
   end

   def set_menu
       set_active_menu("item30") # set active menu to geocaches
   end

end

