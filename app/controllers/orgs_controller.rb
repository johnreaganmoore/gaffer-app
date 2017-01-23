class OrgsController < ApplicationController

  before_action :set_org, except: [:index, :new, :create]

  def index
    @orgs = Org.order('created_at DESC')
  end

  def new
    @org = Org.new
  end

  def create
    @org = Org.new(org_params)
    if @org.save
      flash[:success] = "Org added!"
      redirect_to org_path(@org)
    else
      render 'new'
    end
  end

  def show
  end

  private

  def org_params
    params.require(:org).permit(:name, :external_link)
  end

  def set_org
    @org = Org.friendly.find(params[:id])
  end
end
