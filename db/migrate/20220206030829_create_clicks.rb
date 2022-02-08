class CreateClicks < ActiveRecord::Migration[6.1]
  def change
    create_table :clicks do |t|
      t.string :browser
      t.string :platform
      t.references :pagina, null: false, foreign_key: true

      t.timestamps
    end
  end
end
