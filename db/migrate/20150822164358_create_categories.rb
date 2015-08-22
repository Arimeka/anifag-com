class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories, comment: 'Категории' do |t|
      t.string :name, null: false, default: '', comment: 'Название'

      t.timestamps null: false
    end
  end
end
