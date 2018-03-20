class User < ApplicationRecord
	has_many :interviews, dependent: :destroy
	has_secure_password
	validates :name, presence: true
	validates :email, presence: true, uniqueness: true

	def age #ユーザーの年齢を表示させるメソッド
		date_format = "%Y%m%d"
		# 日付をYYYYmmddの文字列に整形し、整数列に変換。そして10000で除算し、年齢を産出
		(Date.today.try(:strftime, date_format).to_i - self.birthday.try(:strftime, date_format).to_i) / 10000
	end
	
end