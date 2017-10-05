module HappeningsHelper
    def concat_to_date(year:nil, month:nil, day:nil)
        date_string = year+ '-' + month + '-' + day
        date = Date.strptime(date_string,'%Y-%m-%d')
        date.strftime('%Y%m%d')
    end

    def date_valid?(year, month, day)
        Date.new(year, month, day)
    end
end
