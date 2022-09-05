class CreateTvShows < ActiveRecord::Migration[7.0]
  def change
    create_table :tv_shows do |t|
      t.string :title
      t.integer :year
      t.text :synopsis

      t.timestamps
    end
  end
end
