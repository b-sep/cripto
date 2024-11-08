class AddContraintToUserInfo < ActiveRecord::Migration[8.0]
  def change
    add_check_constraint :user_infos, 'value >= 0.1', name: 'value_check'
  end
end
