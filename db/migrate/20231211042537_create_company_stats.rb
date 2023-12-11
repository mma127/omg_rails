class CreateCompanyStats < ActiveRecord::Migration[6.1]
  def change
    create_table :company_stats, comment: "Holds company stats updated after every battle" do |t|
      t.references :company, index: true, null: false
      
      t.integer :infantry_kills_1v1, default: 0, null: false
      t.integer :infantry_kills_2v2, default: 0, null: false
      t.integer :infantry_kills_3v3, default: 0, null: false
      t.integer :infantry_kills_4v4, default: 0, null: false
      
      t.integer :vehicle_kills_1v1, default: 0, null: false
      t.integer :vehicle_kills_2v2, default: 0, null: false
      t.integer :vehicle_kills_3v3, default: 0, null: false
      t.integer :vehicle_kills_4v4, default: 0, null: false
      
      t.integer :infantry_losses_1v1, default: 0, null: false
      t.integer :infantry_losses_2v2, default: 0, null: false
      t.integer :infantry_losses_3v3, default: 0, null: false
      t.integer :infantry_losses_4v4, default: 0, null: false
      
      t.integer :vehicle_losses_1v1, default: 0, null: false
      t.integer :vehicle_losses_2v2, default: 0, null: false
      t.integer :vehicle_losses_3v3, default: 0, null: false
      t.integer :vehicle_losses_4v4, default: 0, null: false
      
      t.integer :wins_1v1, default: 0, null: false
      t.integer :wins_2v2, default: 0, null: false
      t.integer :wins_3v3, default: 0, null: false
      t.integer :wins_4v4, default: 0, null: false
      
      t.integer :losses_1v1, default: 0, null: false
      t.integer :losses_2v2, default: 0, null: false
      t.integer :losses_3v3, default: 0, null: false
      t.integer :losses_4v4, default: 0, null: false
      
      t.integer :streak_1v1, default: 0, null: false, comment: "win streak 1v1"
      t.integer :streak_2v2, default: 0, null: false, comment: "win streak 2v2"
      t.integer :streak_3v3, default: 0, null: false, comment: "win streak 3v3"
      t.integer :streak_4v4, default: 0, null: false, comment: "win streak 4v4"
      
      t.timestamps
    end
  end
end
