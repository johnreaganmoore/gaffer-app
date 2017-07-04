class EmailTemplatesController < ApplicationController
  before_action :authenticate_person!
  before_action :set_email_template, only: [:show, :edit, :update, :destroy]
  before_action :active_org, :set_current_person_tasks, :set_unassigned_tasks, :set_new_submissions, :get_due_tasks

  layout "relate"

  # GET /contact_properties
  # GET /contact_properties.json
  def index
    @email_templates = @active_org.email_templates
  end

  # GET /contact_properties/1
  # GET /contact_properties/1.json
  def show
  end

  # GET /contact_properties/new
  def new
    @email_template = EmailTemplate.new
  end

  # GET /contact_properties/1/edit
  def edit
  end

  # POST /contact_properties
  # POST /contact_properties.json
  def create
    @email_template = EmailTemplate.new(email_template_params)
    @email_template.org_id = @active_org.id

    respond_to do |format|
      if @email_template.save
        format.html { redirect_to email_templates_path, notice: 'Email template was successfully created.' }
        format.json { render :show, status: :created, location: @email_template }
      else
        format.html { render :new }
        format.json { render json: @email_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_properties/1
  # PATCH/PUT /contact_properties/1.json
  def update

    respond_to do |format|
      if @email_template.update(email_template_params)
        format.html { redirect_to email_templates_path, notice: 'Email template was successfully updated.' }
        format.json { render :show, status: :ok, location: @email_template }
      else
        format.html { render :edit }
        format.json { render json: @email_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_properties/1
  # DELETE /contact_properties/1.json
  def destroy
    @email_template.destroy
    respond_to do |format|
      format.html { redirect_to email_templates_url, notice: 'Email template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_template_params
      params.require(:email_template).permit(:name, :body, :org_id)
    end
end
