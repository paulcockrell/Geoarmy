class GeocachesController < ApplicationController
    require 'open-uri'
    require 'cgi'

before_filter :find_geocache,
    :only => [:show, :edit, :update, :destroy]
before_filter :authorize,
    :only => [:new, :edit, :update, :show, :destroy]
before_filter :set_menu

DISTANCE = 20
ITEMS_PER_PAGE = 20

  def set_menu
    set_active_menu("item20") # set active menu to geocaches
  end

  # GET /geocaches
  # GET /geocaches.xml
  def index
    @search = true
    if (params[:commit])
        @geocaches = find_geocaches_by_distance(params[:lat], params[:lon], DISTANCE).paginate :page => params[:page], :order => 'id', :per_page => ITEMS_PER_PAGE
        @center_point = [params[:lat],params[:lon]]
        @distance     = DISTANCE
        @address      = params[:geocache][:address]
    else
        user = get_user
        if(user.nil?)
            @geocaches = Geocache.find(:all).paginate :page=>params[:page], :order=>'id', :per_page=>ITEMS_PER_PAGE
            @center_point = [50,52]
            @distance = DISTANCE
        else
        @address = User.find_by_id(user.id).postcode
        user_geocode = get_geocode @address
        @geocaches = find_geocaches_by_distance(user_geocode[:lat], user_geocode[:lon], DISTANCE).paginate :page => params[:page], :order => 'id', :per_page => ITEMS_PER_PAGE
        @center_point = [user_geocode[:lat],user_geocode[:lon]]
        @distance = DISTANCE
        end
    end
    @title = "Listing all geocaches"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @geocaches }
    end
  rescue
      @geocaches = Geocache.find(:all).paginate :page=>params[:page], :order=>'id', :per_page=>ITEMS_PER_PAGE
      @center_point = [50,52]
      @distance = DISTANCE
      logger.warn "Failed to do maps because the SQL was dodgy! Now listing all geocaches instead..."
  end

  # GET /geocaches/1
  # GET /geocaches/1.xml
  def show
      @user = get_user
      @favorite = @user.favorites.find(:all, :conditions=>['geocache_id=?',@geocache.id])
      @found = @user.found.find(:all, :conditions=>['geocache_id=?',@geocache.id])        
      @connection = @user.connections.find(:all, :conditions=>['connection_id=?',@geocache.user_id])
      @history = show_history
      if (get_geocache_rating(@user.id, @geocache.id).nil?)
          @rating = -1
      else
          @rating = get_geocache_rating(@user.id,@geocache.id).geocache_rating
      end
      geocache_view = View.new
      geocache_view.geocache_id = @geocache.id
      geocache_view.save
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @geocache }
      end
  end
  
  def show_history
     @history = Found.history(@geocache.id).paginate :page=>params[:page], :order=>'created_at', :per_page=>ITEMS_PER_PAGE
  end

  # GET /geocaches/new
  # GET /geocaches/new.xml
  def new
    @geocache = Geocache.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @geocache }
    end
  end

  # GET /geocaches/1/edit
  def edit
      user = get_user
      geocache_id = params[:id]      

      begin
        geocache = Geocache.find(:all, :conditions=>["user_id=? and id=?", user.id, geocache_id])
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempt to acess invalid geocache #{params[:id]}")
        flash[:notice] = "An error occured, please try again"
        redirect_to(:controller=>'profile', :action=>'mygeocaches')
      else
        if geocache.empty?
          flash[:notice] = "You cannot edit this geocache as you did not create it"
          redirect_to(:controller=>'profile', :action=>'mygeocaches')               
        end
      geocache
      end
 end

  # POST /geocaches
  # POST /geocaches.xml
  def create
    params[:geocache][:user_id] = get_user.id # set creator to current logged in user
    @geocache = Geocache.new(params[:geocache])

    respond_to do |format|
      if @geocache.save
        
        #add score to user rank
        add_score_to_rank('upload')
        
        format.html { redirect_to(@geocache, :notice => 'Geocache was successfully created.') }
        format.xml  { render :xml => @geocache, :status => :created, :location => @geocache }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @geocache.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /geocaches/1
  # PUT /geocaches/1.xml
  def update
    respond_to do |format|
      if @geocache.update_attributes(params[:geocache])
        format.html { redirect_to(@geocache, :notice => 'Geocache was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @geocache.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /geocaches/1
  # DELETE /geocaches/1.xml
  def destroy
    @geocache.destroy
    
    #add score to user rank
    del_score_to_rank('upload')
    
    respond_to do |format|
      format.html { redirect_to(geocaches_url) }
      format.xml  { head :ok }
    end
  end

  def manage_geocaches
        @current_user       = get_user
        @uploaded_geocaches = @current_user.geocaches.paginate :page => params[:up_page], :order => 'id', :per_page => 10 unless @current_user.nil?
        @favorite_geocaches = Geocache.all(:joins=>{:favorites, :user}, :conditions=>['users.id=?', @current_user.id]).paginate :page => params[:fa_page], :order => 'id', :per_page => ITEMS_PER_PAGE if params[:id].nil? unless @current_user.nil?
        @found_geocaches    = Geocache.all(:joins=>{:found, :user}, :conditions=>['users.id=?', @current_user.id], :select=>'geocaches.id,geocaches.name,found.created_at as found,lat,lon', :order=>"found ASC").paginate :page => params[:fo_page], :order => 'found ASC', :per_page => ITEMS_PER_PAGE if params[:id].nil? unless @current_user.nil?
  end

  def my_uploaded_geocaches
      user = get_user
      @address = user.postcode
      user_geocode = get_geocode @address
      @center_point = [user_geocode[:lat],user_geocode[:lon]]
      @distance = DISTANCE
      @geocaches = user.geocaches.paginate :page => params[:page], :order => 'id', :per_page => 10
      @my_geocaches = true
      @title = "Listing my uploaded geocaches"
      render :index
  end

  def my_favorite_geocaches
      user = get_user
      @address = user.postcode
      user_geocode = get_geocode @address
      @center_point = [user_geocode[:lat],user_geocode[:lon]]
      @distance = DISTANCE
      @geocaches = Geocache.all(:joins=>{:favorites, :user}, :conditions=>['users.id=?',user.id]).paginate :page => params[:page], :order => 'id', :per_page => ITEMS_PER_PAGE
      @title = "Listing my favorite geocaches"
      render :index
  end

  def my_found_geocaches
      user = get_user
      @address = user.postcode
      user_geocode = get_geocode @address
      @center_point = [user_geocode[:lat],user_geocode[:lon]]
      @distance = DISTANCE
      @geocaches = Geocache.all(:joins=>{:found, :user}, :conditions=>['users.id=?',user.id]).paginate :page => params[:page], :order => 'id', :per_page => ITEMS_PER_PAGE
      @title = "Listing my found geocaches"
      render :index
  end

  def find_geocaches_by_distance(current_lat, current_lon, max_distance)
      query = construct_geocache_distance_query(current_lat,current_lon,max_distance)
      res = Geocache.find_by_sql(query)
  end

  def get_geocaches
      lat = params[:lat]
      lng = params[:lng]
      @result = find_geocaches_by_distance(lat,lng,20)
      respond_to do |format|
          format.html { redirect_to '/' }
          format.js { render :partial=>'get_geocaches', :locals=>{:result=>@result}}
      end
  end

  def get_geocaches_table
      @points = params[:points]
      @points.nil? || @points.size < 5 ? (@geocaches=false) : (@geocaches=true)
      respond_to do |format|
          format.html { redirect_to '/' }
          format.js { render :partial=>'geocache_index_table', :locals=>{:geocaches=>@geocaches, :points=>@points}}
      end
  end

  def save_rating()
      user = get_user
      geo_rating = params[:geo_rating]
      geocache_id = params[:geo_id]

      if (get_geocache_rating(user.id, geocache_id).nil?)
          rating = Rating.new
      else
          rating = get_geocache_rating(user.id, geocache_id)
      end

      rating.user_id = user.id
      rating.geocache_id = geocache_id
      rating.geocache_rating  = geo_rating
      @result = rating.save 
      
      respond_to do |format|
           format.html { redirect_to '/' }
           format.js { render :partial=>'rating', :locals=>{:result=>@result}}
      end
  end

  def get_controlling_team
    Geocache.get_controlling_team(params[:id])
  end


  private
	  def find_geocache
          begin
  		      @geocache = Geocache.find(params[:id])
          rescue ActiveRecord::RecordNotFound
              flash[:notice] = "Geocache not found!"
              redirect_to( :controller=>'profile', :action=>'mygeocaches')
              logger.error("Attempt to access invalid geocache: #{params[:id]}")
          end
	  end

      def construct_geocache_distance_query(current_lat, current_lon, max_distance)
             "select id,name,user_id,lat,lon,(6378*acos(sin((PI()/180)*lat) * sin((PI()/180)*#{current_lat})+cos((PI()/180)*lat)*cos((PI()/180)*#{current_lat})*cos(((PI()/180)*lon)-((PI()/180)*#{current_lon})))*0.621371192) AS distance FROM geocaches HAVING distance <= #{max_distance} ORDER BY distance ASC"
      end

      def get_geocode(address)
          logger.debug 'starting geocoder call for address: '+CGI::escape(address)
          response=open("http://maps.googleapis.com/maps/api/geocode/xml?address=#{CGI::escape(address)}&sensor=false")
          h = Hash.from_xml response
          user_lat = h['GeocodeResponse']['result']['geometry']['location']['lat']
          user_lng = h['GeocodeResponse']['result']['geometry']['location']['lng']
          
          user_lat.empty? ? logger.debug('Geocache response is nil') : logger.debug('Geocache successfull call')
          
          logger.debug "Geocode call lat: "+user_lat
          logger.debug "Geocode call lng: "+user_lng
          return {:success=>true, :lat=>user_lat, :lon=>user_lng}
      rescue
          logger.debug "Failed to open URI to google"
      end

      def get_geocache_rating(user_id, geocache_id)
        Rating.find(:first, :conditions=>['user_id=? AND geocache_id=?', user_id, geocache_id])
      rescue
        nil
      end
end
