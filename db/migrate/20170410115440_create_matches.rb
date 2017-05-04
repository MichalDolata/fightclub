class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.belongs_to :home, foreign_key: true
      t.belongs_to :away, foreign_key: true
      t.integer :home_score
      t.integer :away_score
      t.belongs_to :next_match, foreign_key: true
      t.integer :next_match_type
      t.belongs_to :tournament, foreign_key: true
      t.integer :round_id
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
