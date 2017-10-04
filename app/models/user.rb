require 'open-uri'
class User < ApplicationRecord
    include Clearance::User

    BIT_CONVERSION = 76561197960265728

    def self.create_from_omniauth(uid: nil, real_name: 'anonymous', persona_name:'anonymous', country: nil, provider: nil, email:nil)
        user = User.new
        # TODO need to confirm the flow of filling in email
        user.email = email
        user.uid = User.change_uid_to_32_bit uid_64_bit: uid
        user.provider = provider
        user.real_name = real_name
        user.persona_name = persona_name
        user.country = country
        user.password = SecureRandom.hex(10)
        user.save
        return user
    end

    # def self.find_by_uid(uid_64bit: nil)
    #     self.find_by uid: self.change_uid_to_32bit(uid_64bit)
    # end

    # uid from steam oauth is in 64bit, convert it to 32bit as most of the third party api are using 32bit
    def self.change_uid_to_32_bit(uid_64_bit: nil)
        (uid_64_bit.to_i - self.bit_conversion).to_s
    end

    def self.change_uid_to_64_bit(uid_32_bit: nil)
      (uid_32_bit.to_i + self.bit_conversion).to_s
    end

    def get_user_stats
        api_result = JSON.parse open("https://api.opendota.com/api/players/#{self.uid}").read
        user_stats = parse_user_stats(api_result: api_result)
        user_stats
    end

    def parse_user_stats(api_result: nil)

        if api_result.nil?
            return nil
        end
        User_stats.new(self.id, api_result["profile"]["last_login"], api_result["solo_competitive_rank"], get_user_win_lose)
    end

    def get_user_win_lose
        user_winlose = JSON.parse open("https://api.opendota.com/api/players/#{self.uid}/wl").read

        if user_winlose["win"] == 0 && user_winlose["lose"] == 0
            0
        else
            100 * user_winlose["win"]/(user_winlose["win"] + user_winlose["lose"])
        end
    end



    private

    User_stats = Struct.new(:id, :last_login_date, :solo_mmr, :win_lose) do
        def last_login
            Date.strptime(last_login_date, '%Y-%m-%dT%H:%M:%S')
        end
    end

    def self.bit_conversion
        BIT_CONVERSION
    end
end
