class NetworksController < ApplicationController
  # GET /networks
  # GET /networks.xml
  def index
    @networks = Network.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @networks }
    end
  end

  def show
    if !@network = Network.find_by_name( params[:name] )
			flash[:error] = "'"+params[:name]+"' network does not exist!"
			redirect_to root_path
		else
	    respond_to do |format|
  	    format.html { render :layout => "network" }# show.html.erb
  	    format.xml  { render :xml => @network, :layout => "user_session" }
  	  end
		end
  end

	#get '/:name'
   # "Hello #{name}"
  #end

  def new
    @network = Network.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network }
    end
  end

  def edit
    @network = Network.find(params[:id])
  end

  def create
    @network = Network.new(params[:network])

    respond_to do |format|
      if @network.save
        format.html { redirect_to(@network, :notice => 'Network was successfully created.') }
        format.xml  { render :xml => @network, :status => :created, :location => @network }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @network = Network.find(params[:id])

    respond_to do |format|
      if @network.update_attributes(params[:network])
        format.html { 
					redirect_to :action => "index"
					flash[:notice] = 'Networks was successfully updated.'
				}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.xml
  def destroy
    @network = Network.find(params[:id])
    @network.destroy

    respond_to do |format|
      format.html { redirect_to(networks_url) }
      format.xml  { head :ok }
    end
		redirect_to :controller => "users", :action => "edit"
  end
end
