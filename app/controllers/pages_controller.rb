class PagesController < ApplicationController
  def home
  	@services = Service.limit(4)
  end
end
