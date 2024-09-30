# frozen_string_literal: true

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  ISSUES = [
    'Free Speech',
    'Immigration',
    'Terrorism',
    'Social Security and Medicare',
    'Abortion',
    'Student Loans',
    'Gun Control',
    'Unemployment',
    'Climate Change',
    'Homelessness',
    'Racism',
    'Tax Reform',
    'Net Neutrality',
    'Religious Freedom',
    'Border Security',
    'Minimum Wage',
    'Equal Pay'
  ].freeze

  validates :issue, presence: true, inclusion: { in: ISSUES }

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  def self.find_in_google(search_params)
    articles_list = []
    representative = Representative.find_by(id: search_params['rep_id']).name
    issue = search_params['issue']
    query = URI.encode_www_form_component("#{representative} #{issue}")
    # This didn't work in testing vvvv, might work in production tho?
    # api_key = Rails.application.credentials[:GOOGLE_NEWS_API_KEY]
    # api_key = 'a848621dd8a54067bede6848a8ecc6c8' This one timed out bc too many requests
    api_key = '0a055350a5a84d08aa68a80e0b3d5a22'

    url = "https://newsapi.org/v2/everything?q=#{query}&sortBy=popularity&apiKey=#{api_key}"
    response = Faraday.get(url)
    response = JSON.parse(response.body)

    articles = response['articles']

    articles.each do |article|
      t = article['title']
      d = article['description']
      l = article['url']
      # This is very specific, idk if it's rly necessary vvvv
      # unless NewsItem.exists?(title: t, description: d, link: l, issue: issue)
      articles_list << NewsItem.new(title: t, description: d, link: l, issue: issue) unless NewsItem.exists?(title: t)
      break if articles_list.size == 5
    end
    articles_list
  end
end
