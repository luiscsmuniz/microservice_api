class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def set_permission(permission, system, resource)
    permission.select{ |per| per["system"] == system }.map do |per|
      resource = per["resource"].select{ |rsc| rsc["name"] == resource }.map do |rsc|
        rsc
      end
      {
        system: per["system"],
        resource: resource[0].deep_symbolize_keys
      }
    end
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
