# frozen_string_literal: true

class RenameFipsCodeToStdFipsCode < ActiveRecord::Migration[5.2]
  def change
    rename_column :counties, :fips_code, :std_fips_code
  end
end
