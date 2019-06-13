class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]
  before_action :token,

  def resource
    "tasks"
  end

  def token
    begin
      @decoded_token = self.decoded_token.first
    rescue Exception => e
      render json: {
        errors: e
      }
    end
  end

  # GET /tasks
  def index
    begin
      raise Pundit::NotAuthorizedError, 'Sem permissão para acessar esse recurso.' unless TaskPolicy.new(
          @decoded_token['data']['email'], 
          @decoded_token['data']['permission'],
          self.system,
          self.resource
        ).show?
        
        @tasks = Task.all
        render json: { 
          tasks: @tasks, 
          user: @decoded_token['data']['email'],
          expire_in: Time.at(@decoded_token['exp']).strftime("%d/%m/%Y %H:%M")
        }
    rescue Exception => e
      render json: {
        errors: e
      }
    end
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    begin
      raise Pundit::NotAuthorizedError, 'Sem permissão para acessar esse recurso.' unless TaskPolicy.new(
          @decoded_token['data']['email'], 
          @decoded_token['data']['permission'],
          self.system,
          self.resource
        ).create?
        @task.save
        render json: @task, status: :created, location: @task
    rescue Exception => e
      render json: {
        errors: e
      }
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def task_params
      params.permit(:name, :description)
    end
end
