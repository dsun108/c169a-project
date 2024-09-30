# frozen_string_literal: true

class AddCountyFipsToRepresentatives < ActiveRecord::Migration[5.2]
  def change
    add_column :representatives, :county_fips, :string
  end
end
