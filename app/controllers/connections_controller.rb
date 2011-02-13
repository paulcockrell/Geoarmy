class ConnectionsController < ApplicationController
  
  def index
  end
  
  def manage
      user = get_user
      connections = user.connections
      @connections = User.find(:all, :conditions=>['id in (?)', connections.map {|i| i['connection_id']}]).paginate :page => params[:page], :order => 'id', :per_page => 10
      @title = "Manage my user connections"
  end
  
  def add_connection
      user = get_user
      geo = Hash["connection_id", params[:id], "user_id", user.id]
      @connection = Connection.new(geo)
      if request.post? and @connection.save
          render :partial => 'connection_del', :object => params[:id]
      end
  end

  def delete_connection
      if request.post?
          user = get_user
          @connection = Connection.find(:first, :conditions=>['connection_id = ? and user_id = ?', params[:id],user.id])
          @connection.destroy
          render :partial => 'connection', :object => params[:id]
      end
  end

end
