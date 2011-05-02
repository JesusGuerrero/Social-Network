class DocumentsController < ApplicationController
  def index
  end

  def new
  end

	def create
  end  

	def show
		@d = Document.find(params[:id])
		@d.destroy
		flash[:success] = "Document Removed"
		redirect_to name_path( @network, {:name => params[:name], :tab=>"Documents"})
  end

  def destroy
  end

end
