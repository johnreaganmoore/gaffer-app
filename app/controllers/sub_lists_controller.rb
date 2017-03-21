class SubListsController < ApplicationController
  layout "subs", except: [:show]
  before_action :authenticate_person!
  before_action :set_list, except: [:index, :new, :create]
  before_action :active_org, except: [:index, :show]

  def index
    @org = Org.find(session[:admin_org]["id"])
    puts @org.inspect
    @lists = @org.sub_lists
    puts @lists.inspect
  end

  def new
    @list = SubList.new
  end

  def create
    @list = SubList.new(list_params)
    @list.org_id = session[:admin_org]["id"]

    if @list.save
      flash[:success] = "SubList added!"
      redirect_to edit_list_path(@list)
    else
      render 'new'
    end
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to edit_list_path(@list), notice: 'SubList was successfully updated.' }
        format.json { render :edit, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @memberships = @list.sub_list_memberships
  end

  private

  def list_params
    params.require(:sub_list).permit(:name)
  end

  def set_list
    @list = SubList.find(params[:id])
  end
end
