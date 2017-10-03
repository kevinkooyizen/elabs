class User < ApplicationRecord
  include Clearance::User

    BIT_CONVERSION = 76561197960265728

    def create_from_omniauth(uid:nil, name:'anonymous', country:nil, provider:nil)
        user = User.new
        user.uid = User.change_uid_to_32bit uid_64bit: uid
        user.provider = provider
        user.name = name
        user.country = country
        user.password = SecureRandom.hex(10)
        user.save
        return user
    end

    def self.find_by_uid(uid_64bit: nil)
        self.find_by uid: self.change_uid_to_32bit(uid_64bit)
    end


    def self.change_uid_to_32bit(uid_64bit:nil)
        (uid_64bit.to_i - self.bit_conversion).to_s
    end

    private

    def self.bit_conversion
        BIT_CONVERSION
    end
end
