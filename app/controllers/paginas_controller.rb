
class PaginasController < ApplicationController
  before_action :set_pagina, only: %i[ show edit update destroy ]
  before_action :set_url_by_code, only: %i[ visit ]

  # GET /paginas or /paginas.json
  def index
    @paginas = Pagina.last(10)
  end

  def jsonapi
    render json: PaginaSerializer.new(Pagina.last(10)).serializable_hash.to_json
  end

  # GET /paginas/1 or /paginas/1.json
  def show
    @daily_clicks = @pagina.clicks_by_day
    @browsers_clicks = @pagina.clicks_by_browser
    @platform_clicks = @pagina.clicks_by_platform
  end

  # GET /paginas/new
  def new
    @pagina = Pagina.new
  end

  # GET /paginas/1/edit
  def edit
  end

  def visit
    unless @pagina.present?
      redirect_to '/404.html'
    else
      browser = Browser.new(request.env["HTTP_USER_AGENT"])

      @pagina.set_click(browser)

      redirect_to @pagina.url, target: '_self'
    end
  end

  # POST /paginas or /paginas.json
  def create
    @pagina = Pagina.new(pagina_params)

    respond_to do |format|
      if @pagina.save
        format.html { redirect_to pagina_url(@pagina), notice: "Pagina was successfully created." }
        format.json { render :show, status: :created, location: @pagina }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pagina.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paginas/1 or /paginas/1.json
  def update
    respond_to do |format|
      if @pagina.update(pagina_params)
        format.html { redirect_to pagina_url(@pagina), notice: "Pagina was successfully updated." }
        format.json { render :show, status: :ok, location: @pagina }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pagina.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paginas/1 or /paginas/1.json
  def destroy
    @pagina.destroy

    respond_to do |format|
      format.html { redirect_to paginas_url, notice: "Pagina was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pagina
      @pagina = Pagina.find(params[:id])
    end

    def set_url_by_code
      @pagina = Pagina.find_by(code: params[:short_url])
    end

    # Only allow a list of trusted parameters through.
    def pagina_params
      params.require(:pagina).permit(:url, :code)
    end
end
