class TaskPolicy < ApplicationPolicy
  attr_reader :user, :permission, :system, :resource

  def initialize(user, permission, system, resource)
    @user = user
    @permission = self.set_permission(permission, system, resource)
  end
  
  def show?
    @permission[0][:resource][:actions].include?('show') && @user
  end
 
end
