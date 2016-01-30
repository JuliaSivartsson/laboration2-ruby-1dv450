module ApplicationHelper
    
        def is_admin
        return true if @current_user.name == "admin" #The admin account
    end
end
