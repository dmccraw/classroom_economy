class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    if user.admin?
      can :manage, :all
    elsif user.teacher?
      can :manage, Group do |group|
        group.user_id == user.id
      end

      can :manage, User do |_user|
        unless can_manage = (_user.id == user.id) # can manage self
          unless can_manage = _user.new_record?

            unless can_manage
              # if user is part of one of their groups
              user.groups.each do |group|
                if group.member_of?(_user)
                  can_manage = true
                end
              end
            end
          end
        end
        can_manage
      end

      can :manage, Store do |store|
        can_update = false
        # if store is in a group of the teacher
        user.groups.each do |group|
          if store.group_id == group.id
            can_update = true
            break
          end
        end
        can_update
      end

    elsif user.student?
      can :read, User do |_user|
Rails.logger.red(_user.inspect)
        can_read = false
        # only read users in same groups
        unless can_read = user.in_group_with?(_user)

        end
        can_read
      end

      can :show, Group do |group|
        group.member_of?(user)
      end

      can :show, Store do |store|
        can_show = false
        user.groups.each do |group|
          if store.group_id == group.id
            can_show = true
          end
        end
        can_show
      end
    end
  end
end
