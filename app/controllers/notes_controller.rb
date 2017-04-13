class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  before_action :active_org

  layout "relate"

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
    @contact = Contact.find(params[:contact])
    @contact_id = params[:contact]
  end

  # GET /notes/1/edit
  def edit
    @contact = @note.contact
    @contact_id = @note.contact.id
  end

  # POST /notes
  # POST /notes.json

  def create
    @note = Note.new(note_params)
    @empty_note = Note.new

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note.contact, notice: 'User was successfully created.' }
        format.js   {}
        format.json { render json: @note, status: :created, location: @note }
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    @contact = @note.contact
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @contact, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @contact = @note.contact
    @note.destroy
    respond_to do |format|
      format.html { redirect_to @contact, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:contact_id, :body)
    end
end
