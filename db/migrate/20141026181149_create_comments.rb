class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :ticket, index: true
      t.text :text
      t.string :email
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
