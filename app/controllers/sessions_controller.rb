class SessionsController < Clearance::SessionsController
    # steam oauth needs to bypass rails authenticity check to work
    skip_before_action :verify_authenticity_token, only: :create_from_omniauth

    def sign_up_oauth
        redirect_to helpers.oauth_path(email: params[:oauth]["email"])
    end

    def create_from_omniauth
        auth_hash = request.env["omniauth.auth"]
        email = request.env['omniauth.params']["email"]
        if auth_hash.present?
            # passed steam authentication
            user = User.find_by uid: User.change_uid_to_32_bit(uid_64_bit: auth_hash[:uid]), provider: auth_hash[:provider]

            # first time sign in
            if user.nil?
                user_profile = auth_hash[:profile]

                user = User.create_from_omniauth uid: auth_hash[:uid],
                                                 real_name:auth_hash[:info][:name],
                                                 persona_name: auth_hash[:extra][:raw_info][:personaname],
                                                 country: auth_hash[:info][:location],
                                                 provider: auth_hash[:provider],
                                                 email: SecureRandom.hex(6) + '@example.com',
                                                 avatar_url: auth_hash[:extra][:raw_info][:avatar],
                                                 large_avatar_full: auth_hash[:extra][:raw_info][:avatarfull]

                if user.errors.messages.present?
                    # error in user creation
                    flash[:error] = user.errors.messages
                    return redirect_to root_path
                else
                    # create and sign in the user and redirect them to complete their profile
                    sign_in(user)
                    flash[:notice] = 'Successfully sign in! Please complete your profile'
                    # TODO change to user profile path
                    return redirect_to root_path
                end

            end

            # existing user oauth sign in flow
            sign_in(user)
            flash[:notice] = 'Successfully sign in!'
            return redirect_to root_path
        else
            # failed steam authentication
            flash[:error] = 'Please make sure you can sign in your Steam account!'
            return redirect_to root_path
        end
    end

    private

    def oauth_params

    end

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
    end

    def url_for_signed_in_users
        url_after_create
    end
end
