class Searchingforajob < Spinach::FeatureSteps
  feature 'Searching for a job'
  
  Then 'I cleanup' do
    page.cleanup!
  end

  Given 'I navigate to the web site' do
    visit "http://fluxx.io/"
    sleep 2
    $home_page = current_url
    
    #page.find(".icon-color-accent a").click
    page.find("#menu-item-15408 a").click
    sleep 2
    puts current_url
    
    
    #allLinks = page.all("#menu-item-15407 a").collect { |a| a[:href] } #menu-item-16775
    allLinks = page.all("#menu-item-16775 a").collect { |a| a[:href] }
    
    #allLinks.each do |link|
    #  visit link
    #  sleep 2
    #end
    
  end
  
  And 'I am logged' do
    visit $home_page
    page.find(".wpb_wrapper a", :text => "Learn more").click
    sleep 1
    puts current_url
    
    
    
  end
  
  And 'I type' do
    puts current_url
  end
  
  
  
end





