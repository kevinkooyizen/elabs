class HappeningsController < ApplicationController
    include HappeningsHelper
    include SearchHelper

    def index
       @happenings = Happening.all
    end

    def search
        @happenings = Happening.all
        params_valid = true
        date_from = PseudoDate.new(search_params[:"from(1i)"],search_params[:"from(2i)"],search_params[:"from(3i)"])
        date_to = PseudoDate.new(search_params[:"to(1i)"],search_params[:"to(2i)"],search_params[:"to(3i)"])

        if !date_from.valid?
            flash[:error] = 'Invalid date!'
            params_valid = false
        end

        if !date_to.valid?
            flash[:error] = 'Invalid date!'
            params_valid = false
        end

        if params_valid
            @happenings = Happening.happening_search(name: search_params[:name],
                                                     location: search_params[:location],
                                                     date_lower_range: date_from.to_string,
                                                    date_upper_range: date_to.to_string)
        end

        # this is to return the params keyed in by user when the page is refreshed
        # can be omitted if ajax is implemented
        @params = search_params.to_h
        @params[:from] = date_from.valid? ? date_from.to_date : Date.today
        @params[:to] = date_to.valid? ? date_to.to_date : Date.today

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
