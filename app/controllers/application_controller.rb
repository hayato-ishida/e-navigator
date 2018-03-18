class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :set_current_user

	def set_current_user
	 	@current_user = User.find_by(id: session[:user_id])
	end

	#未ログインユーザーの不正なアクセスを制限するためのユーザー認証メソッド
	def authenticate_user
		if @current_user == nil
			flash[:notice] = "ログインが必要です"
			redirect_to("/login")
		end
	end

	#ログイン済みユーザーに不要な画面を表示・アクセスさせないためのメソッド
	def forbid_login_user
		if @current_user
			flash[:notice] = "すでにログインしています"
			redirect_to("/users/#{@current_user.id}")
		end
	end

	#管理者に不要な画面を表示・アクセスさせないためのメソッド
	def forbid_administrator
		if @current_user.id == 0  #ログイン済みユーザーが管理者の場合
			flash[:notice] = "アクセスを禁止されています" #通知
			redirect_to("/users/index") #面接一覧画面にリダイレクト
		end
	end

end
