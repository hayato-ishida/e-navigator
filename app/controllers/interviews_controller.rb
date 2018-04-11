class InterviewsController < ApplicationController
  before_action :ensure_correct_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @user = User.find_by(id: params[:user_id])
    @interviews = @user.interviews
  end

  def new
    @user = User.find_by(id: params[:user_id])
    @interview = Interview.new
  end

  def create
    @user = User.find_by(id: params[:user_id])
    @interview = @user.interviews.new(interview_params)
    if @interview.save
      flash[:success] = "面接日時を登録しました"
      redirect_to user_interviews_path
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(id: params[:user_id])
    @interview = @user.interviews.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:user_id])
    @interview = @user.interviews.find_by(id: params[:id])
    if @interview.update(interview_params)
      redirect_to user_interviews_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find_by(id: params[:user_id])
    @interview = @user.interviews.find_by(id: params[:id])
    @interview.destroy
    redirect_to user_interviews_path
  end

	def ensure_correct_user
		@interview = Interview.find_by(id: params[:id])
		if @interview.user_id != current_user.id
			flash[:notice] = "他のユーザーの面接日時の編集及び削除は許可されていません"
			redirect_to users_path
		end
	end

  private

    def interview_params
      params.require(:interview).permit(:datetime)
    end
end
