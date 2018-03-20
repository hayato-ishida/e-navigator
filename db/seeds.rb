# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(id: 0, name: "管理者", email: "admin@example.com", password: "admin")
User.create(id: 1, name: "石田隼人", email: "hayato@example.com", sex: "男", university: "立教大学", password: "password", birthday: "1991-06-21")
User.create(id: 2, name: "面接花子", email: "hanako@example.com", sex: "女", university: "東京大学", password: "password", birthday: "1990-01-01")

Interview.create(id: 1, user_id: 1, datetime: "2018-03-30 13:00:00", status: "却下")
Interview.create(id: 2, user_id: 1, datetime: "2018-03-28 11:00:00", status: "保留")
Interview.create(id: 3, user_id: 1, datetime: "2018-03-31 15:00:00", status: "承認")
Interview.create(id: 4, user_id: 2, datetime: "2018-03-23 13:00:00", status: "却下")
Interview.create(id: 5, user_id: 2, datetime: "2018-03-25 11:00:00", status: "保留")
Interview.create(id: 6, user_id: 2, datetime: "2018-03-26 15:00:00", status: "承認")
