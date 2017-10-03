class User < ApplicationRecord
  include Clearance::User
  # validates :email, presence:true, uniqueness: true, unless: :skip_email_validation?

    BIT_CONVERSION = 76561197960265728

  attr_accessor :skip_email_validation

  def skip_email_validation?
      self.skip_email_validation
  end

    def self.create_from_omniauth(uid:nil, name: 'anonymous', country: nil, provider: nil)
        user = User.new
        # TODO need to confirm the flow of filling in email
        user.email = SecureRandom.hex(5) + '@example.com'
        user.skip_email_validation= true
        user.uid = User.change_uid_to_32_bit uid_64_bit: uid
        user.provider = provider
        user.name = name
        user.country = country
        user.password = SecureRandom.hex(10)
        user.save
        return user
    end

    # def self.find_by_uid(uid_64bit: nil)
    #     self.find_by uid: self.change_uid_to_32bit(uid_64bit)
    # end


    def self.change_uid_to_32_bit(uid_64_bit: nil)
        (uid_64_bit.to_i - self.bit_conversion).to_s
    end

    private

    def self.bit_conversion
        BIT_CONVERSION
    end
end
