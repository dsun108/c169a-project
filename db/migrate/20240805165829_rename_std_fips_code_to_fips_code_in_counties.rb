# frozen_string_literal: true

class RenameStdFipsCodeToFipsCodeInCounties < ActiveRecord::Migration[5.2]
  def change
    rename_column :counties, :std_fips_code, :fips_code
  end
end
