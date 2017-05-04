class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :teams_count
      t.text :description
      t.datetime :start_date
      t.belongs_to :creator
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
