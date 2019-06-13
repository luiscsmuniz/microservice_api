class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]
  before_action :token,

  def resource
    "tasks"
  end

  def token
    puts @teste
    begin
      @decoded_token = self.decoded_token_test
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
          @decoded_token[0]['data'][0]['email'], 
          @decoded_token[0]['data'][0]['permission'],
          self.system,
          self.resource
        ).show?
        
        @tasks = Task.all
        render json: { 
          tasks: @tasks, 
          data: @decoded_token[0]['data'],
          exp: @decoded_token[0]['exp'],
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

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
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
      params.require(:task).permit(:name, :description)
    end
end
