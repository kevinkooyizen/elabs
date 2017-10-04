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

    private

    def self.bit_conversion
        BIT_CONVERSION
    end
end
