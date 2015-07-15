class TasksController < ApplicationController
  before_action :set_task, except: [:new, :index, :create]

  def index
    @already_need_perform = current_user.tasks.already_need_perform.order(start_date: :asc)
    @in_future = current_user.tasks.in_future.order(start_date: :asc)
    @performed_tasks = current_user.tasks.where(status: 1).order(start_date: :desc)
  end

  def new
    @task = Task.new(start_date: Time.now + 1.hour)
  end

  def create
    task = current_user.tasks.create(task_params)

    task.create_sms_notification if params[:task][:notify_by_sms]

    redirect_to root_path
  end

  def edit
  end

  def update
    @task.sms_notification.delete unless params[:task][:notify_by_sms]

    @task.update(task_params)
    
    redirect_to root_path
  end

  def destroy
    @task.destroy()
    redirect_to root_path
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
