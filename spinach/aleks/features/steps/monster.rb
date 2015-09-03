class OpeningWebsite < Spinach::FeatureSteps
  
  Then 'I cleanup' do
    page.cleanup!
  end

  And 'I navigate to MONSTER.COM' do
    visit "/"
    #visit 'http://www.dummymag.com/'
    #sleep 1
  end

  And 'I verify that I land on expected page' do
    #links = page.all(".menu a").collect {|a| a[:href]}
    #puts links
  end
  
  Then 'I search for SQA' do
    #puts page.find("a.icon-facebook.btn").should be_visible
    #puts page.find("a.icon-twitter.btn").should be_visible
    
    #other_links = page.all(".footer-info a").collect {|a| a[:href]}#.each {|l| visit l}
    #count_other_links = page.all(".footer-info a").collect {|a| a[:href]}.count

    #if count_other_links > 0
      #puts "We found #{count_other_links} link#{'s' if count_other_links > 1} on #{current_url} page."
      
      #other_links.each do |link|
      #  visit link
      #  sleep 2
      #  puts current_url.yellow
      #  page.evaluate_script('window.history.back()')
      #  
      #end
    #else
      #puts "I did not find links on #{current_url} page!".red
    #end
    
    #page.attach_file("customer_logo", File.join(File.dirname(__FILE__), '../support/pirat.gif'))
    #page.attach_file("customer_logo", File.join(File.dirname(__FILE__), '../support/pirat.gif'))
    #File.open('../../support/pirat.gif', "a")
    #File.open("#{Time.now.to_i}.txt", 'a') {|f| f.write("write your stuff here\n") }
    #puts File.chdir(__FILE__), '../support'

    visit "/"
    puts current_url
    
    #2.times do
    #  File.open("../master/features/support/pit_version.txt", "r").each {|e| puts e }
    #  sleep 2
    #  File.open("../master/features/support/pit_version.txt", "w") { |file| file << "#{Time.now.to_i}\n" }
    #  sleep 2
    #  File.open("../master/features/support/pit_version.txt", "r").each {|e| puts e }
    #end
    

  end
  
end






