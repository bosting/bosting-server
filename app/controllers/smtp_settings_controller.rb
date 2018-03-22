# frozen_string_literal: true

class SmtpSettingsController < ApplicationController
  before_action :set_parent_hosting_server
  before_action :set_smtp_setting, only: %i[edit update destroy]

  def index
    @smtp_settings = @hosting_server.smtp_settings
  end

  def new
    @smtp_setting = SmtpSetting.new
  end

  def edit; end

  def create
    @smtp_setting = @hosting_server.smtp_settings.build(smtp_setting_params)

    if @smtp_setting.save
      redirect_to hosting_server_smtp_settings_path, notice: t('flash.smtp_setting.create')
    else
      render :new
    end
  end

  def update
    if @smtp_setting.update(smtp_setting_params)
      redirect_to hosting_server_smtp_settings_path, notice: t('flash.smtp_setting.update')
    else
      render :edit
    end
  end

  def destroy
    @smtp_setting.destroy
    redirect_to hosting_server_smtp_settings_path, notice: t('flash.smtp_setting.destroy')
  end

  private

  def set_smtp_setting
    @smtp_setting = SmtpSetting.find(params[:id])
  end

  def smtp_setting_params
    params.require(:smtp_setting).permit(:name, :value)
  end
end
