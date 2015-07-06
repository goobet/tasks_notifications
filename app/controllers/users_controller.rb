class UsersController < ApplicationController
  def profile
    @already_need_perform = current_user.tasks.already_need_perform.order(start_date: :asc)
    @in_future = current_user.tasks.in_future.order(start_date: :asc)
    @performed_tasks = current_user.tasks.where(status: 1).order(start_date: :desc)
  end
end
