class ChangeValueCoumnNameInStatuses < ActiveRecord::Migration
  def change
    rename_column :statuses, :value, :label
  end
end
