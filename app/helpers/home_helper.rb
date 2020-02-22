module HomeHelper
  def is_welcome
    params[:controller] == 'home' && params[:action] == 'welcome'    	
  end
end
