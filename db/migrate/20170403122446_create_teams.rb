class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.belongs_to :user, index: true, null: false
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
