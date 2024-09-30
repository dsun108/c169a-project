# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :news_item

  validates :value, presence: true, inclusion: { in: 1..5 }
end
