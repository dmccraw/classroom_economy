# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

teacher = User.new(
  first_name: "Test",
  last_name: "Teacher",
  email: "teacher@test.com",
  user_type: 2
)
teacher.password = "password"
teacher.save!

user = User.create(
  first_name: "Test",
  last_name: "Admin",
  email: "admin@test.com",
  user_type: 10
)
user.password = "password"
user.save!

group = Group.create(
  name: "Test Class",
  user_id: teacher.id
)

student = User.create(
  first_name: "Test",
  last_name: "Student",
  user_type: 1
)
student.password = "password"
student.save!

Membership.create(
  user_id: student.id,
  group_id: group.id
)