class PhotosController < ApplicationController
  before_filter :get_attachable
  
protected
  def get_attachable
    request_path = request.request_uri
    logger.info "REQUEST PATH: #{request_path}"
    object_type = request_path.sub(/^\//, '').split('/').shift.singularize
    @attachable = case object_type
    when 'photo' then nil
    when 'show' then Show.find_by_permalink(params[:show_id]) or raise ActiveRecord::RecordNotFound
    else
      (object_type.camelize.constantize).find(params[(object_type + '_id').to_sym]) or raise ActiveRecord::RecordNotFound
    end
  end

public
  # GET /photos
  # GET /photos.xml
  def index
    @photos = if @attachable.nil?
      Photo.find :all, :conditions => {:parent_id => nil}, :order => 'created_at DESC'
    else
      @attachable.photos.find :all, :conditions => {:parent_id => nil}, :order => 'created_at DESC'
    end

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photos.to_xml }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @photo.to_xml }
    end
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1;edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        @attachable.photos << @photo unless @attachable.nil?
        flash[:notice] = 'Photo was successfully uploaded.'
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :created, :location => photo_url(@photo) }
        format.js do
          responds_to_parent do
            render :update do |page|
              @photo.attachments :reload
              @attachment = @photo.attachment_to @attachable unless @attachable.nil?
              page.insert_html :bottom, "attachments", :partial => 'photos/attachment', :locals => { :attachment => @attachment }
              page.visual_effect :highlight, dom_id(@attachment)
            end
          end          
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors.to_xml }
        format.js do
          responds_to_parent do
            render :update do |page|
              # TODO: update the page with an error message
            end
          end          
        end
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.xml  { head :ok }
    end
  end
  
  def reorder
    unless @attachable.nil?
      params[:attachments].each_with_index do |a, i|
        Attachment.update a, :position => i + 1
      end
    end
    respond_to do |wants|
      wants.js { render :nothing => true }
    end
  end
end
