class HappeningsController < ApplicationController
    include HappeningsHelper
    def index
       @happenings = Happening.all
    end

    def show

    end

    def search
        permitted_params = search_params
        @happenings = Happening.all
        params_valid = true

        if !Date.valid_date?(search_params[:"from(1i)"].to_i, search_params[:"from(2i)"].to_i, search_params[:"from(3i)"].to_i)
            flash[:error] = 'Invalid date!'
            params_valid = false
        end

        if !Date.valid_date?(search_params[:"to(1i)"].to_i, search_params[:"to(2i)"].to_i, search_params[:"to(3i)"].to_i)
            flash[:error] = 'Invalid date!'
            params_valid = false
        end
        
        
        if params_valid
            @happenings = Happening.happening_search(name: search_params[:name],
                                                     location: search_params[:location],
                                                     date_lower_range:
                                                             concat_to_date(year: search_params[:"from(1i)"], month: search_params[:"from(2i)"], day: search_params[:"from(3i)"]),
                                                    date_upper_range:
                                                            concat_to_date(year: search_params[:"to(1i)"], month: search_params[:"to(2i)"], day: search_params[:"to(3i)"])
                                                    )
        end

        render 'index'
    end

    private
    def search_params
        params.require(:search).permit(:name,
                                          :location,
                                          :"from(1i)",
                                          :"from(2i)",
                                          :"from(3i)",
                                          :"to(1i)",
                                          :"to(2i)",
                                          :"to(3i)")
    end
end
