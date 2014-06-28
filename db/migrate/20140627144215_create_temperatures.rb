class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.float :value ,  limit: 4
      t.integer :sensor_id

      t.timestamps
    end
  end
end
