class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  enum sex: {
    unselected: 0,
    male: 1,
    female: 2
  }
  has_many :microposts, dependent: :destroy

  # パスワード入力なしでの更新を許可する
  def update_without_current_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def age #ユーザーの年齢を表示させるメソッド
    date_format = "%Y%m%d"
    (Date.today.try(:strftime, date_format).to_i - self.birthday.try(:strftime, date_format).to_i) / 10000
  end
end