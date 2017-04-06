class AddGeneratedToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :generated, :boolean, default: false
  end
end
