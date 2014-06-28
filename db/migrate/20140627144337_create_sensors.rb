class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :name
      t.string :unique_id
      t.float :calibration

      t.timestamps
    end
  end
end
