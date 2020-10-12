class DocumentsController < AuthenticatedController
  before_action :load_document, only: [:edit, :show, :destroy, :update]

  def index
    @documents = Document.with_user_id(current_user.id)
  end

  def new
    @document = Document.new
  end

  def create
    document = Document.new(document_params.merge(user_id: current_user.id))

    if document.save
      redirect_to documents_path
    else
      render :new
    end
  end

  def show
    @document = Document.find(params[:id])
  end

  def edit
  end

  def update
    maybe_remove_attachments(@document)
    if @document.update_attributes(document_params)
      redirect_to documents_path
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_path
  end

  private

  def document_params
    params.require(:document).permit(:title, :description, files: [])
  end

  def load_document
    @document = Document.with_user_id(current_user.id).find_by(id: params[:id])
    if @document.nil?
      redirect_to root_path, flash: { error: 'Document not found' }
    end
  end

  def maybe_remove_attachments(document)
    ids_to_remove = params[:delete_attachments]
    return if ids_to_remove.blank?

    ids_to_remove.each do |id|
      file = document.files.find_by(id: id)
      file&.purge
    end
  end
end
