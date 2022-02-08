class CreatePaginas < ActiveRecord::Migration[6.1]
  def change
    create_table :paginas do |t|
      t.string :url
      t.string :code

      t.timestamps
    end
  end
end
