# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :prepare_for_mobile

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  ITEMS_PER_PAGE = 20
  FOUND_SCORE    = 2
  UPLOAD_SCORE   = 10

  def privacy
      render :template => 'legal/privacy_policy.erb'
  end

  def terms
      render :template => 'legal/terms_and_conditions.erb'
  end
  
  
  private
  
  def add_score_to_rank(action)
    case action
      when 'found'
          user = get_user
          user.rank += FOUND_SCORE
          user.save
      when 'upload'
          user = get_user
          user.rank += UPLOAD_SCORE
          user.save
      else 
    end
  end
  
  def del_score_to_rank(action)
    case action
      when 'found'
          user = get_user
          user.rank -= FOUND_SCORE
          user.save
      when 'upload'
          user = get_user
          user.rank -= UPLOAD_SCORE
          user.save
      else 
    end
  end

  def get_active_menu
      session[:active_menu]
  end

  def set_active_menu(item)
      session[:active_menu] = item
  end
 
  def get_user
      User.find_by_id(session[:user_id])
  end

  def authorize
      unless User.find_by_id(session[:user_id])
          session[:original_uri] = request.request_uri
          uri = session[:original_uri]
          flash[:notice] = "You must first be logged in to access this part of the site!"
          redirect_to({:controller => "home", :action => "index"})
      end
  end

  def arccos(x)
      Math.atan2(Math.sqrt(1.0-x*x), x)
  end

  def mobile_device?
      session[:mobile_param] == "true" ? (return true) : (return false)
  end
  helper_method :mobile_device?

  def prepare_for_mobile
     session[:mobile_param] = params[:mobile] if params[:mobile]
     request.format = :mobile if mobile_device?
  end
end
