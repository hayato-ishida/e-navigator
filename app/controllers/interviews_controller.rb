class InterviewsController < ApplicationController
	#未ログインユーザーの不正なアクセスを制限するためのユーザー認証メソッド
	before_action :authenticate_user
	#ログイン済みのユーザーが違うidのユーザ情報の編集を制限するメソッド
	before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
	#一般ユーザーの管理者権限乱用を制限するメソッド
	before_action :restrict_authority, {only: [:status, :status_update]}
	#管理者に不要な画面を表示・アクセスさせないためのメソッド
	before_action :forbid_administrator, {only: [:new, :create, :edit, :update, :destroy]}

	#get "users/:id/interviews" => "interviews#index"
	def index
		@interviews = Interview.where(user_id: params[:id]).order(datetime: 'asc') #送信されたidとユーザーidが一致する面接を昇順で変数に格納
		@user = User.find_by(id: params[:id]) ##"new.html.erb"でインスタンス変数を利用するため、送信されたidと一致するユーザーを変数に格納
	end

	#get "users/:id/interviews/new" => "interviews#new"
	def new
		@interview = Interview.new #"new.html.erb"でインスタンス変数を利用するため、空のオブジェクトを用意
	end

	#post "users/:id/interviews/create" => "interviews#create"
	def create #入力フォームから送信されたパラメーターで面接を新規作成
		@interview = Interview.new(
			user_id: @current_user.id,
			datetime: params[:datetime],
			status: "保留",
		)
		if @interview.save #新規面接登録成功の場合
			flash[:notice] = "面接日程を申請しました" #通知
			redirect_to("/users/#{@current_user.id}/interviews") #面接一覧画面にリダイレクト
		else
			render("interviews/new") #面接新規作成画面を再表示
		end
	end

	#get "users/:id/interviews/:id/edit" => "interviews#edit"
	def edit
		@interview = Interview.find_by(id: params[:id]) #IDに合致する面接をオブジェクトに格納
	end

	#post "users/:id/interviews/:id/update" => "interviews#update"
	def update
		@interview = Interview.find_by(id: params[:id]) #IDに合致するユーザーをオブジェクトに格納
		@interview.datetime = params[:datetime] #面接日程を送信されたパラメーターで上書き
		@interview.status = "保留" #承認状態を「保留」で上書き
		if @interview.save #面接情報更新成功の場合
			flash[:notice] = "面接日程を変更しました" #通知
			redirect_to("/users/#{@current_user.id}/interviews") #面接一覧画面にリダイレクト
		else
			render("interviews/edit") #面接日程変更画面を再表示
		end
	end

	#get "users/:id/interviews/:id/status" => "interviews#status"
	def status
		@interview = Interview.find_by(id: params[:id]) #IDに合致する面接をオブジェクトに格納
		@user = User.find_by(id: @interview.user_id) ##"status.html.erb"でインスタンス変数を利用するため、interviewsテーブルのuser_idと一致するユーザーを変数に格納
	end

	#post "users/:id/interviews/:id/status_update" => "interviews#status_update"
	def status_update
		@interview = Interview.find_by(id: params[:id]) #IDに合致する面接をオブジェクトに格納
		@status_before_change = @interview.status #変更前の承認状態を保存
		@interview.status = params[:status] #承認状態を送信されたパラメーターで上書き
		@interview.save #承認状態更新
		if Interview.where(user_id: @interview.user_id).where(status: "承認").count > 1 #同一ユーザーで2つ以上の日程が承認された場合
			@interview.status = @status_before_change #承認状態を変更前の承認状態に戻す
			flash[:notice] = "既に別の日程を承認しています" #通知
			redirect_to("/users/#{@interview.user_id}/interviews/#{@interview.id}/status") #承認状態更新画面にリダイレクト
		else
			@interview.save #承認状態更新
			flash[:notice] = "承認状態を更新しました" #通知
			redirect_to("/users/index") #ユーザー一覧画面にリダイレクト
		end
	end

	#post "users/:id/interviews/:id/destroy" => "interviews#destroy"
	def destroy
		@interview = Interview.find_by(id: params[:id]) #IDに合致する面接をオブジェクトに格納
		@interview.destroy #オブジェクトを削除
		flash[:notice] = "面接日程を削除しました" #通知
		redirect_to("/users/#{@current_user.id}/interviews") #面接一覧画面にリダイレクト
	end

	def ensure_correct_user #ログイン済みのユーザーが違うidのユーザ情報の編集を制限するメソッド
		@interview = Interview.find_by(id: params[:id])#IDに合致する面接をオブジェクトに格納
		if @interview.user_id != @current_user.id #Interviewsテーブルのユーザーidとログイン済みユーザーidが異なる場合
			flash[:notice] = "権限がありません" #通知
			redirect_to("/users/#{@current_user.id}/interviews") #面接一覧画面にリダイレクト
		end
	end

	#一般ユーザーの管理者権限乱用を制限するメソッド
	def restrict_authority
		if @current_user.id != 0 #ログイン済みユーザーが管理者でない場合
			flash[:notice] = "権限がありません" #通知
			redirect_to("/users/#{@current_user.id}/interviews") #面接一覧画面にリダイレクト
		end
	end

end
