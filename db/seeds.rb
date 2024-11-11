# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

## Create UserInfos

params1 = { credit_card_token: 'token111', user_document: '111999', value: 10 }
user1 = UserInfo.new(params1)

params2 = { credit_card_token: 'token222', user_document: '222999', value: 20 }
user2 = UserInfo.new(params2)

UserInfoCreateOrUpdate.new(user_info: user1, params: params1).execute
UserInfoCreateOrUpdate.new(user_info: user2, params: params2).execute
