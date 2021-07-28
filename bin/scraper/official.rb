#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    # These are too inconsistent to split programatically
    REMAP = {
      'Minister for Development Cooperation and Nordic Cooperation'  => ['Minister for Development Cooperation', 'Minister for Nordic Cooperation'],
      'Minister for Culture and Minister for Ecclesiastical Affairs' => ['Minister for Culture', 'Minister for Ecclesiastical Affairs'],
      'Minister for Employment and minister for Gender Equality'     => ['Minister for Employment', 'Minister for Gender Equality'],
      'Minister for Children and Education'                          => ['Minister for Children', 'Minister for Education'],
    }.freeze

    field :name do
      tds[0].css('img/@alt').text.tidy
    end

    field :position do
      return REMAP.fetch(raw_position, raw_position) unless raw_position.to_s.empty?

      # These two are empty on the main list, so get the details from
      # their individual page
      return 'Minister for Social Affairs and senior citizens' if name == 'Astrid Krag'
      return 'Minister of Housing' if name == 'Kaare Dybvad Bek'
    end

    private

    def tds
      noko.css('td')
    end

    def raw_position
      tds[1].xpath('text()').first.text.tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      # 'position' is a list of 1 or more positions
      member_container.flat_map do |member|
        data = fragment(member => Member).to_h
        [data.delete(:position)].flatten.map { |posn| data.merge(position: posn) }
      end
    end

    private

    def member_container
      noko.css('table.ankiro-results').xpath('.//tr[td[@class="cellPic"]]')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
