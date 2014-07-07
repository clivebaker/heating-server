class AddPiToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :pi, :string
  end
end
