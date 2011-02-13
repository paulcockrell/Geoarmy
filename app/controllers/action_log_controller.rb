class ActionLogController < ApplicationController

  ITEMS_PER_PAGE = 20

  def index
      @current_user = get_user
      @action_log = ActionLog::get_actions(@current_user).paginate :page=>params[:page], :order=>'created_at', :per_page=>ITEMS_PER_PAGE
  end

end
