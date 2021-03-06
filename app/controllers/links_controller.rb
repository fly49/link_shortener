class LinksController < ApplicationController
  def index
    @link = Link.new
  end

  def show
    redirect_to Link.get(params[:short_url])
  end

  def create
    @link = Link.new
    @link.url = permitted_params.fetch(:url)
    if @link.valid?
      cookies[:keys] = @link.process_cookies(cookies[:keys])
      @path_key = @link.to_key
    else
      flash.now[:danger] = I18n.t('link.invalid')
    end
    
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
  
  private
  
  def permitted_params
    params.require(:link).permit(:url)
  end
end
