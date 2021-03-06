module SessionsHelper
	
	def login(user)
		session[:user_id] = user.id
		@current_user = user
	end

	def current_user
		@current_user || User.find_by({id: session[:user_id]})
	end

  def logged_in?
    if current_user == false
      return false
    else
      return true
    end
  end

	def logout
		@current_user = session[:user_id] = nil
		redirect_to welcome_path
	end

	def redirect_unauthenticated
    	unless logged_in?
      		flash[:alert] = "Sorry, you must be logged in to donate."
      		return redirect_to welcome_path
    	end
	end
end
