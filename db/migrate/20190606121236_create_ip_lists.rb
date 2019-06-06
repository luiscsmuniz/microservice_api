class CreateIpLists < ActiveRecord::Migration[5.2]
  def change
    create_table :ip_lists do |t|
      t.string :ip
      t.boolean :state
      t.time :start_time
      t.time :end_time
      t.timestamps

      t.index [:ip], name: 'index_ip_uniqueness', unique: true
    end
  end
end
