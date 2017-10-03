class SessionsController < Clearance::SessionsController
    skip_before_action :verify_authenticity_token, only: :create_from_omniauth

    def create_from_omniauth

    end

    def test
        render 'test'
    end
end
