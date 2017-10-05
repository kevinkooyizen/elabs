class Event < ApplicationRecord
    def self.title(title=nil)
        if title.present?
            where('title alike ?', "%#{title}%")
        else
            all
        end
    end

    def self.location(location=nil)
        if location.present?
            where('location alike ?', "%#{location}%")
        else
            all
        end
    end

    def self.time(date_lower_range = nil, date_upper_range = nil)
        date_lower_range||= self.default_date__lower_range
        date_upper_range||= self.default_date__upper_range
        if location.present?
            where('time >= ? and time <= ?', date_lower_range, date_upper_range)
        end
    end

    def self.event_search(title:nil, location:nil, date_lower_range:nil, date_upper_range:nil)
        self.title(title).location(location).time(date_lower_range, date_upper_range)
    end

    private

    def self.default_date__lower_range
        '20010101'
    end

    def self.default_date__upper_range
        '20300101'
    end
    
end
