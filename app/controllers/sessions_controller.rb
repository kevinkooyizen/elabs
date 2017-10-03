class SessionsController < Clearance::SessionsController
    skip_before_action :verify_authenticity_token, only: :create_from_omniauth

    def create_from_omniauth
        auth_hash = request.env["omniauth.auth"]
        if auth_hash.present?
            # passed steam authentication
            user = User.find_by uid: User.change_uid_to_32_bit(uid_64_bit: auth_hash[:uid]), provider: auth_hash[:provider]

            # first time sign in
            byebug
            if user.nil?
                user = User.create_from_omniauth uid: auth_hash[:uid], name:auth_hash[:info][:name], country: auth_hash[:info][:location], provider: auth_hash[:provider]
                if user.errors.messages.present?
                    # error in user creation
                    flash[:error] = user.errors.messages
                    return redirect_to root_path
                else
                    # sign in the user and redirect them to complete their profile
                    sign_in(user)
                    flash[:notice] = 'Successfully sign in! Please complete your profile!'
                    # TODO change to user profile path
                    return redirect_to root_path
                end

            end

            # existing user flow
            sign_in(user)
            flash[:notice] = 'Successfully sign in!'
            return redirect_to root_path
        else
            # failed to authenticate steam account
            flash[:error] = 'Please make sure you can sign in your Steam account!'
            return redirect_to root_path
        end


    end

    def test
        render 'test'
    end

    private

    def redirect_signed_in_users
        if signed_in?
            redirect_to url_for_signed_in_users
        end
    end

    def url_after_create
        #  TODO to be decided
        root_path
    end

    def url_after_destroy
        #  TODO to be decided
        root_path
        # sign_in_url
    end

    def url_for_signed_in_users
        url_after_create
    end
end
