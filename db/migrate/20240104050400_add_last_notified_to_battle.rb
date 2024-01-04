class AddLastNotifiedToBattle < ActiveRecord::Migration[6.1]
  def change
    add_column :battles, :last_notified, :datetime, comment: "Last time a notification was sent to players"
  end
end
