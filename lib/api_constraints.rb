class ApiConstraints
    def initializ(options)
        @version = options[:version]
        @default = options[:default]
    end
    
    def matches?(req)
        @default || req.headers['Accept'].include?("application/vnd.apiApplication.v#{@version}")
    end
end