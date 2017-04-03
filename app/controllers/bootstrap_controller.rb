class BootstrapController < ApplicationController
  before_action :require_login, only: [:panel, :panel_edit]

  def index
  end

  def bracket
  end

  def panel

  end

  def panel_edit
  end
end
