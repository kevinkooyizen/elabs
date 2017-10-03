module SessionsHelper
    def oauth_path(email:nil)
        "/auth/steam?email=#{email}"
    end
end
