class FoundController < ApplicationController

  def index
  end
  
  def add_found
      user = get_user
      geo = Hash["geocache_id", params[:id], "user_id", user.id]
      @found = Found.new(geo)
      if request.post? and @found.save
          #add score to user rank
          add_score_to_rank('found')
          render :partial => 'found_del', :object => params[:id]
      end
  end

  def delete_found
      if request.post?
          user = get_user
          @found = Found.find(:first, :conditions=>['geocache_id = ? and user_id = ?', params[:id],user.id])
          @found.destroy
          #remove score from user rank
          del_score_to_rank('found')
          render :partial => 'found', :object => params[:id]
      end
  end

end
