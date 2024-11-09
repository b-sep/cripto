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

UserInfo.create!(
  credit_card_token: '123A0#',
  user_document: '111.999.000-22',
  value: 100.0
)

UserInfo.create!(
  credit_card_token: '223A0#',
  user_document: '111.888.000-22',
  value: 120.1
)
