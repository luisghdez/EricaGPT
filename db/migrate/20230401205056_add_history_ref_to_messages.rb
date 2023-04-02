class AddHistoryRefToMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :history, foreign_key: true
  end
end
