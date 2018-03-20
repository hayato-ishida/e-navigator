class UsersController < ApplicationController
	#未ログインユーザーの不正なアクセスを制限するためのユーザー認証メソッド
	before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
	#ログイン済みユーザーに不要な画面を表示・アクセスさせないためのメソッド
	before_action :forbid_login_user, {only: [:top, :new, :create, :login_form, :login]}
	#ログイン済みのユーザーが違うidのユーザ情報の編集を制限するメソッド
	before_action :ensure_correct_user, {only: [:edit, :update]}
	#管理者に不要な画面を表示・アクセスさせないためのメソッド
	before_action :forbid_administrator, {only: [:show, :edit, :update]}

	#get "/" => "users#top"
	def top
	end

	#get "users/login" => "users#login_form"
	def login_form
	end

	#post "users/login" => "users#login"
	def login
		@user = User.find_by(email: params[:email]) #送信されたemailに一致するユーザーをオブジェクトに格納
		if @user && @user.authenticate(params[:password]) #ユーザーの存在と暗号化されたパスワードの存在を確認出来た場合
			session[:user_id] = @user.id  #ユーザーのidをセッションidにする
			flash[:notice] = "ログインしました" #通知
			redirect_to("/users/index") #ユーザー一覧画面にリダイレクト
		else #ユーザーの存在と暗号化されたパスワードの存在を確認出来ない場合
			@error_message = "メールアドレスまたはパスワードが間違っています" #通知
			@email = params[:email] #送信されたemailの値を初期値としてオブジェクトに格納
			@password = params[:password] #送信されたpasswordの値を初期値としてオブジェクトに格納
			render("users/login_form")  #ログインフォームを再表示
		end
	end

	#get "users/new" => "users#new"
	def new
		@user = User.new #"new.html.erb"でインスタンス変数を利用するため、空のオブジェクトを用意
	end

	#post "users/create" => "users#create"
	def create  #入力フォームから送信されたパラメーターで新規作成、オブジェクトに格納
		@user = User.new(
			name: params[:name],
			email: params[:email],
			password: params[:password],
			sex: params[:sex],
			birthday: params[:birthday],
			university: params[:university]
		)
		if @user.save #新規ユーザー登録成功の場合
			session[:user_id] = @user.id  #ユーザーidをセッションidにする
			flash[:notice] = "ユーザー登録が完了しました"  #通知
			redirect_to("/users/index") #ユーザー一覧画面にリダイレクト
		else  #新規ユーザー登録失敗の場合
			render("users/new") #ユーザー新規作成画面を再表示
		end
	end

	#get "users/index" => "users#index"
	def index
		@users = User.where.not(id: @current_user.id, created_at: 'desc').where.not(id: 0) #自分と管理者を除く全ユーザーを作成日付の降順で表示
	end

	#get "users/:id" => "users#show"
	def show
		@user = User.find_by(id: params[:id]) #IDに合致するユーザー情報をオブジェクトに格納
	end

	#get "users/:id/edit" => "users#edit"
	def edit
		@user = User.find_by(id: params[:id]) #IDに合致するユーザーをオブジェクトに格納
	end

	#post "users/:id/update" => "users#update"
	def update
		@user = User.find_by(id: params[:id]) #IDに合致するユーザーをオブジェクトに格納
		@user.name = params[:name] #ユーザー名を送信されたパラメーターで上書き
		@user.sex = params[:sex] #性別を送信されたパラメーターで上書き
		@user.birthday = params[:birthday] #生年月日を送信されたパラメーターで上書き
		@user.university = params[:university] #生年月日を送信されたパラメーターで上書き
		if @user.save #ユーザー情報更新成功の場合
			flash[:notice] = "ユーザー情報を編集しました"  #通知
			redirect_to("/users/#{@user.id}") #ユーザー詳細画面にリダイレクト
		else #ユーザー情報更新失敗の場合
			render("users/edit")  #ユーザー情報変更画面を再表示
		end
	end

	#post "logout => "users#logout"
	def logout
		session[:user_id] = nil #セッションidを空値にする→セッションを切る
		flash[:notice] = "ログアウトしました" #通知
		redirect_to("/") #トップ画面にリダイレクト
	end

	def ensure_correct_user #ログイン済みのユーザーが違うidのユーザ情報の閲覧・編集を制限するメソッド
	  	if @current_user.id != params[:id].to_i #ログイン済みユーザーidと送信されるユーザーidが異なる場合
	  		flash[:notice] = "権限がありません"  #通知
	  		redirect_to("/users/#{@current_user.id}") #ユーザー詳細画面にリダイレクト
	  	end
	end

end
