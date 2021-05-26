class AddUserIdToArticles < ActiveRecord::Migration[6.1]
  def change
    add_reference :articles, :user, foreign_key: { to_table: :users }
  end
end
