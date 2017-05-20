class ContactPropertiesController < ApplicationController
  before_action :authenticate_person!
  before_action :set_contact_property, only: [:show, :edit, :update, :destroy]
  before_action :active_org

  layout "relate"

  # GET /contact_properties
  # GET /contact_properties.json
  def index
    @contact_properties = @active_org.contact_properties
  end

  # GET /contact_properties/1
  # GET /contact_properties/1.json
  def show
  end

  # GET /contact_properties/new
  def new
    @contact_property = ContactProperty.new
  end

  # GET /contact_properties/1/edit
  def edit
  end

  # POST /contact_properties
  # POST /contact_properties.json
  def create
    @contact_property = ContactProperty.new(contact_property_params)
    @contact_property.org_id = @active_org.id

    respond_to do |format|
      if @contact_property.save
        format.html { redirect_to contacts_path, notice: 'Contact property was successfully created.' }
        format.json { render :show, status: :created, location: @contact_property }
      else
        format.html { render :new }
        format.json { render json: @contact_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_properties/1
  # PATCH/PUT /contact_properties/1.json
  def update

    respond_to do |format|
      if @contact_property.update(contact_property_params)
        format.html { redirect_to contact_properties_path, notice: 'Contact property was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact_property }
      else
        format.html { render :edit }
        format.json { render json: @contact_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_properties/1
  # DELETE /contact_properties/1.json
  def destroy
    @contact_property.destroy
    respond_to do |format|
      format.html { redirect_to contact_properties_url, notice: 'Contact property was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_property
      @contact_property = ContactProperty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_property_params
      params.require(:contact_property).permit(:property, :data_type, :show_in_table, :org_id)
    end
end
