class MunerisController < ApplicationController
  def dashboard
  end

  def profile
  end

  def network
  end

  def map
  end

  def people
  	@users = User.all
  end
end
