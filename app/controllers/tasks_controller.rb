class TasksController < ApplicationController
  before_action :set_task, except: [:new, :index, :create]

  def new
    @task = Task.new(start_date: Time.now + 1.hour)
  end

  def create
    Task.create(task_params) do |t|
      t.user = current_user
    end
    
    return redirect_to profile_path
  end

  def edit
  end

  def update
    @task.update(task_params)
    
    return redirect_to profile_path
  end

  def destroy
    @task.destroy()
    redirect_to profile_path
  end

  def index
    redirect_to profile_path
  end

  def mark_as_performed
    @task.save_as_performed
    redirect_to :back
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :start_date, :repeat_count, 
      :every_minutes, :every_hours, :every_days, :every_months, :every_years)
  end

end
