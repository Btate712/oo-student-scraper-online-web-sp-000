require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students_array = []
    doc = Nokogiri::HTML(open(index_url))
    students = doc.css(".student-card")
    students.each do |student|
      student_hash = {}
      student_hash[:profile_url] = student.css("a")[0]['href']
      student_hash[:name] = student.css(".student-name").text
      student_hash[:location] = student.css(".student-location").text
      students_array << student_hash
    end
    students_array
  end

  # scrape_profile_page scrapes social media accounts (twitter, linkedin, github,
  # and blog), profile quote, and bio and returns a hash in the form of:
  # => {:twitter=>"http://twitter.com/flatironschool",
  #   :linkedin=>"https://www.linkedin.com/in/flatironschool",
  #   :github=>"https://github.com/learn-co,
  #   :blog=>"http://flatironschool.com",
  #   :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your
  #    reputation. Be notorious.\" - Rumi",
  #   :bio=> "I'm a school"
  #  }
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    socials = doc.css(".social-icon-container")
    sites = []
    student_hash = {}
    # scrape social media URLs into sites array
    socials.css("a").each do |site|
      sites << site['href']
    end
    # pull social media sites into hash
    sites.each do |site|
      if site.include?("linkedin")
        student_hash[:linkedin] = site
      elsif site.include?("twitter")
        student_hash[:twitter] = site
      elsif site.include?("github")
        student_hash[:github] = site
      else
        student_hash[:blog] = site
      end
    end
    # scrape and store profile quote
    student_hash[:profile_quote] = doc.css(".profile-quote").text
    # scrape and store bio
    student_hash[:bio] = doc.css(".content-holder .description-holder p").text
    student_hash
  end




end
