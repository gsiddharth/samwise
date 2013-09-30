########### History of Changes ################################
# (1) Added attr_accessible :provider, :uid, :name
# (2) Added device :omniauthable, :omniauth_provider
###############################################################
class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
    attr_accessible :provider, :uid, :name

    def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
        user = User.where(:provider => auth.provider, :uid => auth.uid).first
        unless user
            user = User.create(name:auth.extra.raw_info.name,
                               provider:auth.provider,
                               uid:auth.uid,
                               email:auth.info.email,
                               password:Devise.friendly_token[0,20]
                              )
        end
        user
    end
end
