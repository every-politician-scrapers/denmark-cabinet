#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    # These are too inconsistent to split programatically
    REMAP = {
      'Minister for Development Cooperation and Nordic Cooperation'  => ['Minister for Development Cooperation', 'Minister for Nordic Cooperation'],
      'Minister for Culture and Minister for Ecclesiastical Affairs' => ['Minister for Culture', 'Minister for Ecclesiastical Affairs'],
      'Minister for Employment and minister for Gender Equality'     => ['Minister for Employment', 'Minister for Gender Equality'],
      'Minister for Transport and minister for Gender Equality'      => ['Minister for Transport', 'Minister for Gender Equality'],
      'Minister of the Interior and Housing'                         => ['Minister of the Interior', 'Minister of Housing'],
      'Minister for Children and Education'                          => ['Minister for Children', 'Minister for Education'],
    }.freeze

    def name
      tds[0].css('img/@alt').text.tidy
    end

    def position
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

  class Members
    def member_container
      noko.css('table.ankiro-results').xpath('.//tr[td[@class="cellPic"]]')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
