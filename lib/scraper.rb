require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student_array = []
    student_card = doc.css("div.roster-cards-container div.student-card")
    student_card.each_with_index do |card, i|
      student_hash = {
      :name => card.css("div.card-text-container h4.student-name").text,
      :location => card.css("div.card-text-container p.student-location").text,
      :profile_url => card.css("a").attr("href").value
    }
      student_array << student_hash
    end
    student_array    
  end

  

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    profile_hash = {
      :profile_quote => doc.css("div.main-wrapper div.vitals-container div.vitals-text-container div.profile-quote").text,
      :bio => doc.css("div.main-wrapper div.details-container div.bio-block div.bio-content div.description-holder p").text
    }
    socials = doc.css("div.main-wrapper div.vitals-container div.social-icon-container a")
    socials.each do |social|
        link = social.attr("href")
        if link.include?("twitter")
          profile_hash[:twitter] = link
        elsif link.include?("linkedin")
          profile_hash[:linkedin] = link
        elsif link.include?("github")
          profile_hash[:github] = link
        else
          profile_hash[:blog] = link
        end
    end
    profile_hash
  end
end

