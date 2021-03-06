class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only:[:show, :edit, :update]
  before_action :correct_user, only: [:destroy]
  
  def index    
    if logged_in?
    @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
    end
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクが正常に投稿されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'タスクが投稿されませんでした'
      render 'tasks/index'
    end
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to tasks_path
    else
      flash[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end
  
  def edit
  end
  
  def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました。'
    redirect_to root_url
  end

  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
  end

#Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end


