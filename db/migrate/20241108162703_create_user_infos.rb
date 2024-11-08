class CreateUserInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :user_infos do |t|
      t.string :user_document, null: false
      t.string :credit_card_token, null: false
      t.float :value, null: false

      t.timestamps
    end
  end
end
