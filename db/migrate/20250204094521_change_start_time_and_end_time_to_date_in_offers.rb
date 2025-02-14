class ChangeStartTimeAndEndTimeToDateInOffers < ActiveRecord::Migration[8.0]
  def change
    change_column :offers, :start_time, :date
    change_column :offers, :end_time, :date
  end
end
