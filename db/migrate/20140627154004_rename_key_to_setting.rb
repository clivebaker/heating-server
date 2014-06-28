class RenameKeyToSetting < ActiveRecord::Migration
  def change

rename_column :settings, :key, :setting

  end
end
