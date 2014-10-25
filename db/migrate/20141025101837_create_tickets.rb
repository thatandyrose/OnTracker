class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.belongs_to :user, index: true
      t.text :body
      t.string :email
      t.string :name
      t.string :subject
      t.string :department

      t.timestamps
    end
  end
end
