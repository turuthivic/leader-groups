class ArchivesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # before_action :set_archive, only: [:show, :edit, :update, :destroy]

  # GET /archives
  # GET /archives.json
  def index
    @archives = Archive.all
  end

  # GET /archives/1
  # GET /archives/1.json
  def show
  end

  # GET /archives/new
  def new
    # @archive = Archive.new
  end

  # GET /archives/1/edit
  def edit
    authorize! :edit, @archive
  end

  # POST /archives
  # POST /archives.json
  def create
    # @archive = Archive.new(archive_params)

    respond_to do |format|
      if @archive.save
        format.html { redirect_to @archive, notice: 'Archive was successfully created.' }
        format.json { render :show, status: :created, location: @archive }

        # send documents to telegram users
        chat_id = "#{ENV['TELEGRAM_CHAT_ID']}"
        @archived_books = @archive.documents
        @archive_title = @archive.title
        @archive_description = @archive.description

        Telegram.send_message(chat_id, "Document - Upload
          #{@archive_title.upcase}\n
          #{@archive_description}
          ", true, [])
        @archived_books.each do |document|
          book = "public"+document.book.url.split("?")[0]
          Telegram.send_document(chat_id, book)
        end

      else
        format.html { render :new }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /archives/1
  # PATCH/PUT /archives/1.json
  def update
    respond_to do |format|
      if @archive.update(archive_params)
        format.html { redirect_to @archive, notice: 'Archive was successfully updated.' }
        format.json { render :show, status: :ok, location: @archive }
      else
        format.html { render :edit }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archives/1
  # DELETE /archives/1.json
  def destroy
    @archive.destroy
    respond_to do |format|
      format.html { redirect_to archives_url, notice: 'Archive was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_archive
    #   @archive = Archive.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def archive_params
      params.require(:archive).permit(:title, :description, :archive_id, documents_attributes: [:id, :book, :_destroy])
    end
end
