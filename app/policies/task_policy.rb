class TaskPolicy < ApplicationPolicy
  attr_reader :user, :permission, :system, :resource

  def initialize(user, permission, system, resource)
    @user = user
    @permission = self.set_permission(permission, system, resource).first
  end

  def show?
    @permission[:resource][:actions].include?('show')
  end

  def create?
    @permission[:resource][:actions].include?('create')
  end
 
end
