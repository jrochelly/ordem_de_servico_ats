class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    year = params[:year]
    unless year
      @services = Service.where('year = ?', Date.today.strftime("%Y")).includes(:category)
    else
      @services = Service.where('year = ?', year).includes(:category)
    end
    @years = Service.all.select(:year).group(:year)
  end

  # GET /services/new
  def new
    @service = Service.new
    # Shows current and next year
    @supplies = [Date.today.year, Date.today.year + 1]
    @categories = Category.all
  end

  # GET /services/1/edit
  def edit
    @categories = Category.all
    @supplies = [Date.today.year, Date.today.year + 1]
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to services_path, notice: 'Service was successfully created.' }
        format.json { render action: 'index', status: :created, location: @service }
      else
        format.html { render action: 'new' }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to services_path, notice: 'Service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:description, :qty, :value, :category_id, :year)
    end
end
