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
      # can :manage, Group do |group|
      #   group.user_id == user.id || group.new_record?
      # end
      can :manage, Group, user_id: user.id
      can :manage, User, id: user.id

      can :manage, User do |_user|
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
        can_manage
      end

      can :manage, Job do |job|
        user.in_group?(job.group_id) || job.new_record?
      end

      can :manage, Store do |store|
        user.in_group?(store.group_id) || store.new_record?
      end

      can :manage, Account do |account|
        user.in_group?(account.group_id) || account.new_record?
      end

      can :manage, Dispute do |dispute|
        user.in_group?(dispute.group_id) || dispute.new_record?
      end

      can :manage, StoreOwner do |store_owner|
        user.in_group?(store_owner.store.group_id)
      end

      can :manage, StoreManager do |store_manager|
        user.in_group?(store_manager.store.group_id)
      end

      can :manage, Charge do |charge|
        user.in_group?(charge.group_id)
      end

    elsif user.student?
      can :read, User do |_user|
        can_read = false
        # only read users in same groups
        unless can_read = user.in_group_with?(_user)

        end
        can_read
      end

      can :read, Group do |group|
        group.member_of?(user)
      end

      can :index, Store do |store|
        true
      end

      can [:read, :create], Store do |store|
        can_read = false
        user.groups.each do |group|
          if store.group_id == group.id
            can_read = true
          end
        end
        can_read
      end

      can :update, Store do |store|
        store.owner?(user)
      end

      # can read jobs in their own group
      can :read, Job do |job|
        user.in_group?(job.group_id)
      end

      can :read, Account do |account|

        user.owns_or_manages_account?(account)
      end

      can :create, Dispute do |dispute|
        user.in_group?(dispute.group_id) || dispute.new_record?
      end

      can :read, Dispute do |dispute|
        user.owns_or_manages_account?(dispute.transaction.to_account) || user.owns_or_manages_account?(dispute.transaction.from_account)
      end

      can [:create, :destroy], StoreOwner do |store_owner|
        store_owner.store.owner?(user)
      end

      can :manage, StoreManager do |store_manager|
        store_manager.store.owner?(user)
      end

      can :read, Charge do |charge|
        user.id == charge.user_id
      end

    end
  end
end
