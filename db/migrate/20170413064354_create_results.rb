class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.belongs_to :match, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :home_score
      t.integer :away_score

      t.timestamps
    end
  end
end
