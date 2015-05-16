class LeaveforstudentsController < ApplicationController
  #filter_resource_access
  filter_access_to :all

  # GET /leaveforstudents
  # GET /leaveforstudents.xml
  def index
    @position_exist = current_login.staff.position if current_login.isstaff==true
    @filters = Leaveforstudent::FILTERS

    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
       @leaveforstudents = Leaveforstudent.with_permissions_to(:index).send(params[:show]).paginate(:order => 'leave_startdate', :per_page => 20, :page => params[:page])
    else
      @leaveforstudents = Leaveforstudent.with_permissions_to(:index).search(params[:search]).paginate(:per_page => 20, :page => params[:page]) 
    end

    respond_to do |format|
      if current_login.isstaff==true 
        if @position_exist 
          format.html # index.html.erb
          format.xml  { render :xml => @leaveforstudents }
        else
          format.html {redirect_to "/home", :notice =>t('position_required')+ t('leaveforstudent.title2')}
          format.xml  { render :xml => @leaveforstudent.errors, :status => :unprocessable_entity }
        end
      else
        format.html # index.html.erb
        format.xml  { render :xml => @leaveforstudents }
      end
    end
  end

  # GET /leaveforstudents/1
  # GET /leaveforstudents/1.xml
  def show
    @leaveforstudent = Leaveforstudent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @leaveforstudent }
    end
  end

  # GET /leaveforstudents/new
  # GET /leaveforstudents/new.xml
  def new
    @leaveforstudent = Leaveforstudent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @leaveforstudent }
    end
  end

  # GET /leaveforstudents/1/edit
  def edit
    @leaveforstudent = Leaveforstudent.find(params[:id])
  end

  # POST /leaveforstudents
  # POST /leaveforstudents.xml
  def create
    @leaveforstudent = Leaveforstudent.new(params[:leaveforstudent])

    respond_to do |format|
      if @leaveforstudent.save
        flash[:notice] = t('leaveforstudent.title2')+" "+t('created')
        format.html { redirect_to(@leaveforstudent) }
        format.xml  { render :xml => @leaveforstudent, :status => :created, :location => @leaveforstudent }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @leaveforstudent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /leaveforstudents/1
  # PUT /leaveforstudents/1.xml
  def update
    @leaveforstudent = Leaveforstudent.find(params[:id])

    respond_to do |format|
      if @leaveforstudent.update_attributes(params[:leaveforstudent])
        flash[:notice] = t('leaveforstudent.title2')+" "+t('updated')
        format.html { redirect_to(@leaveforstudent) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @leaveforstudent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /leaveforstudents/1
  # DELETE /leaveforstudents/1.xml
  def destroy
    @leaveforstudent = Leaveforstudent.find(params[:id])
    @leaveforstudent.destroy

    respond_to do |format|
      format.html { redirect_to(leaveforstudents_url) }
      format.xml  { head :ok }
    end
  end
  
  def approve_coordinator
    @leaveforstudent = Leaveforstudent.find(params[:id])
  end
  
  def approve_warden
    @leaveforstudent = Leaveforstudent.find(params[:id])
  end
  
end
