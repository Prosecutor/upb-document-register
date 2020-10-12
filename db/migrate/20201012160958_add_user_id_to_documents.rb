class AddUserIdToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :user_id, :integer

    user = User.first
    if user
      execute <<~SQL
        UPDATE documents
        SET user_id = #{user.id}
        WHERE user_id IS NULL
      SQL
    end

    change_column :documents, :user_id, :integer, null: false
  end
end
