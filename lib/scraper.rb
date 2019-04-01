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

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    socials = doc.css(".social-icon-container")
    sites = []
    student_hash = {}
    socials.css("a").each do |site|
      sites << site['href']
    end
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
    student_hash[:profile_quote] = doc.css(".profile-quote").text
    binding.pry
  end




end
