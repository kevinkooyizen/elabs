module SearchHelper

    PseudoDate = Struct.new(:yr, :mth ,:d) do
        def year
            yr.to_i
        end

        def month
            mth.to_i
        end

        def day
            d.to_i
        end

        def valid?
            Date.valid_date?(year, month, day)
        end

        def to_date
            Date.new(year, month, day)
        end

        def to_string
            to_date.strftime('%Y%m%d')
        end
    end

    def can_string_to_number?(string)
        string.match?(/^\d+(\.\d+)?$/)
    end


end
