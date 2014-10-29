class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :activity_type
      t.belongs_to :ticket, index: true
      t.belongs_to :comment, index: true
      t.string :user_name

      t.timestamps
    end
  end
end
