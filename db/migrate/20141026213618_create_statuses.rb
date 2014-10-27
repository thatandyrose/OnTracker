class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
