class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == 'admin'
      can :manage, :all
    elsif user.role == "moderator"
      can [:read, :show,:create,:destroy,:tag, :download], Article
      can [:update, :delete_attachment] , Article, :user_id => user.id
      can [:update, :favorited], User, :id => user.id
      can [:published,:show], User
    elsif user.role == "author"
      can [:read, :create, :tag, :download], Article
      can [:update, :delete_attachment] , Article, :user_id => user.id
      can [:update, :favorited], User, :id => user.id
      can [:published,:show], User
    elsif user.role == "banned"
      can [:read, :tag, :download], Article
      can :favorited, User, :id => user.id
      can [:published,:show], User
    end

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
  end
end
