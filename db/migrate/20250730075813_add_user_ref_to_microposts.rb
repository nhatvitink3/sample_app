class AddUserRefToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_reference :microposts, :user, null: false, foreign_key: true
  end
end
