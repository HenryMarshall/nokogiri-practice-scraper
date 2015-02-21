require 'open-uri'
require 'date'

class Article < ActiveRecord::Base

  def self.test_method
    "foo"
  end

  def self.get_sports_articles

    100.times do |page_number|
      # TODO: Add exception handling
      articles_page = self.get_articles_page page_number
      articles_address = self.get_article_addresses articles_page
      self.process_articles! articles_address
    end


  end

  private

    def self.process_articles! articles_address
      articles_address.each do |article_address|
        article_page = self.get_page article_address
        values = self.article_values article_page
        self.save_values values
      end
    end

    def self.get_articles_page page_number=1
      articles_address = "http://www.tmz.com/category/tmzsports/"
      self.get_page "#{articles_address}#{page_number}"
    end

    def self.get_page articles_address
      begin
        page = Nokogiri::HTML(open(articles_address))
      rescue Exception=> e
        puts "Exception #{e}"
        puts "Unable to fetch #{address}"
      ensure
        sleep 2.0 + rand
        page
      end
    end

    def self.get_article_addresses page
      articles = page.css('article.tmzsports')
      articles.map do |article|
        article.css(".headline")[0]['href']
      end
    end

    def self.article_values article
      date_and_author = article.css('.article-posted-date').inner_text.strip
                               .match(/(^.+)\sBY\s(.*)/)

      {
        title: article.css('.headline').inner_text
                      .gsub(/\n/, '').gsub(/\s{2,}/, ' ').strip,
        posted_date: date_and_author[1],
        author: date_and_author[2],
        body: article.css('.article-content p').inner_text
      }
    end

    def self.save_values values
      article = Article.new
      # FIXME: There's a better way to do this :-/
      article[:title] = values[:title]
      article[:author] = values[:author]
      article[:body] = values[:body]
      article[:posted_date] = values[:posted_date]

      if article.save
        puts "#{values[:title]} saved to db"
      else
        raise "Did not save"
      end
      article
    end
end
