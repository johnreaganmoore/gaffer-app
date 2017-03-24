class OrgsController < ApplicationController
  layout "league_admin", except: [:show]

  before_action :authenticate_person!, except: [:show]
  before_action :set_org, except: [:index, :new, :create]
  before_action :active_org, except: [:index, :show, :new, :create]


  def index
    @orgs = current_person.administered_orgs
    # @orgs = Org.order('created_at DESC')
  end

  def new
    @org = Org.new
  end

  def create
    @org = Org.new(org_params)

    if @org.save
      org_creator = current_person
      org_creator.add_role :admin, @org
      session[:admin_org] = @org
      case request.subdomain
      when "collect"
        redirect_to teams_path
      when "register"
        redirect_to leagues_path
      when "subs"
        redirect_to list_index_path
      else
        redirect_to edit_org_path(@org)
      end

      flash[:success] = "Organization was successfully created!"

      @org.create_managed_account(current_person)
      @org.record_accept_terms(request.remote_ip)

    else
      render 'new'
    end
  end

  def update

    respond_to do |format|
      if @org.update(org_params)
        format.html { redirect_to edit_org_path(@org), notice: 'Organization was successfully updated.' }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: @org.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    unless current_person.has_role? :admin, @org
      redirect_to @org, notice: 'You must be an organization admin in order to edit this organization.'
    end
  end

  private

  def org_params
    params.require(:org).permit(:name, :external_link)
  end

  def set_org
    @org = Org.friendly.find(params[:id])
  end
end
