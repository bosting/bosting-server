class ApacheVariationsController < ApplicationController
  before_action :load_hosting_server
  before_action :set_apache_variation, only: [:edit, :update, :destroy]

  def index
    @apache_variations = @hosting_server.apache_variations
  end

  def new
    @apache_variation = ApacheVariation.new
  end

  def edit
  end

  def create
    @apache_variation = @hosting_server.apache_variations.build(apache_variation_params)

    if @apache_variation.save
      redirect_to hosting_server_apache_variations_path(@hosting_server), notice: t('flash.apache_variation.create')
    else
      render :new
    end
  end

  def update
    if @apache_variation.update(apache_variation_params)
      redirect_to hosting_server_apache_variations_path(@hosting_server), notice: t('flash.apache_variation.update')
    else
      render :edit
    end
  end

  def destroy
    @apache_variation.destroy
    redirect_to hosting_server_apache_variations_path(@hosting_server), notice: t('flash.apache_variation.destroy')
  end

  private
  def set_apache_variation
    @apache_variation = ApacheVariation.find(params[:id])
  end

  def apache_variation_params
    params.require(:apache_variation).permit(:name, :ip, :apache_version_id, :php_version_id)
  end
end
