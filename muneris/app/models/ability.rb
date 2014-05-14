class Ability
  include CanCan::Ability

  def initialize(user)
 
    user ||= User.new
        if user.admin?
            can :notification, :all
            can :feed, :all
        else
            
        end

        # alias_action :create, :read, :update, :destroy, :to => :crud
        # can :crud, Bill, :active => true, :user_id => user.id
        # can :manage, Friendships, :active => true, :user_id => user.id
    end

  end
end
