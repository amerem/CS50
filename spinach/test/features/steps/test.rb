class Test < Spinach::FeatureSteps
  feature 'Test'
  
  Then 'I cleanup' do
    page.cleanup!
  end

  Given 'I do first' do
    if ENV['APP_ENV'].blank?
      host = ENV['APP_HOST'].blank? ? "http://survey-dev-plat.streetline.com/session/new" : ENV['APP_HOST']
    else
      host = "http://survey-"+ ENV['APP_ENV'] + ".streetline.com/session/new"
    end

    visit host
    
    puts current_url
  end

  Then 'I do second' do
    if ENV['apphost'].blank?
      host = ENV['apphost'].blank? ? "http://survey-dev-plat.streetline.com/session/new" : ENV['apphost']
    else
      host = "http://survey-"+ ENV['apphost'] + ".streetline.com/session/new"
    end

    visit host
    
    puts current_url
  end

  And 'I do third' do
    visit "http://garage-portal-staging.streetline.com/alt/account_users/sign_in"
    sleep 1
  end

  When 'I do fourth' do
    $start_time = Time.now.to_i
    sleep 1
    $user_name = "sln_qa"
    fill_in("username", :with => $user_name)
    fill_in("password", :with => "please")
    page.find(:css, "#owner_login").set(true)
    page.find(".btn-blue.left").click
    sleep 2
  end

  And 'I do fifth' do
    visit "http://garage-portal-staging.streetline.com/events"
    sleep 2
    page.find(".ui-icon.ui-icon-circle-triangle-e").click
    sleep 3
    puts page.find(:css, ".ui-datepicker-calendar td", :text => "10").click
    sleep 5
    page.find(:css, ".ui-datepicker-calendar td", :text => "30").click
    sleep 5
    
    $end_time = Time.now.to_i
    t = $end_time - $start_time
    puts Time.at(t).utc.strftime("%H:%M:%S")
  end

  When 'I do sixth' do
    #puts page.should have_content("Walgreens Lot")
    page.find(:css, ".btn_location-info", :text=> "Walgreens Lot").click
    sleep 1
    
    page.click_on("Availability")
    sleep 2
    
    page.find("#track_feed").click
    sleep 3
    
    auth_key = page.find(".box p.top1em.bold").text
    auth_key = auth_key.gsub("http://garage-api-dev-plat.streetline.com/publish/states?auth_key=", "")
    auth_key = auth_key.gsub("&lookup_code=TEST_LOT&availability=<NONE|SOME|LOTS>", "")
    puts auth_key
  end
  
  Then 'I pars JSON' do
    $environment = "http://garage-api-dev-plat.streetline.com/"
    $single_access_token = "YxMlbUEvqrNWXIBu8qsJvw"
    $lot_total_count = rand(60 ..80).round()
    $lookup_code = "TEST_LOT"
      
    #lot_total_curl_body = "curl -sS -GET  '#{$environment}publish/lot_total?count=#{$lot_total_count}&auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}'"
    #puts lot_total_curl_result = (`#{lot_total_curl_body}`).red
    
    
    
#=begin      
    sleep 1
    facilities = "'http://garage-api-dev-plat.streetline.com/facilities/17418/counts.json?deployment_id=36'"
    callResp = `curl -sS -GET #{facilities}`
    parsed_json = JSON.parse(callResp)
    puts aaa = parsed_json["STUDENT"].to_f
    puts "++++++++++++++++++++++\n"
    
    
    
   
    puts key = `curl -sS "http://parker2-dev-plat.streetline.com/api/customer_auth_string/public.txt"`
    $key = key.gsub("\n", "")
    
    puts facilities_call_response = `curl -sS -GET "http://parker2-dev-plat.streetline.com/api/#{$key}/availability/f4/sanmateo/availability.json"`
    
    
    #facilities_call_response = `#{curlBody}`
    parsed_json = JSON.parse(facilities_call_response)
    
    id = parsed_json["availability"]["parkingAggregateIds"][5].gsub("pf", "")
    puts id = id.gsub("_STUDENT", "")
    
    if parsed_json["availability"]["parkingAggregateIds"][5].include?("_STUDENT") == true
    
      puts bbb = parsed_json["availability"]["parkingAggregateAvailabilityCounts"]
      bbb = bbb[5].to_f
    
      puts "\n"
    
      puts aaa == bbb
    else
      puts "Oops!"
    end
#=end    
    
  When 'timer started' do
    $start_time = Time.now.to_i
  end
  
  When 'timer stoped' do
    $end_time = Time.now.to_i
    
    #run_time = (($end_time - $start_time) / 60).round(2).to_s
    
    raw_diff_time = $end_time - $start_time
    run_time = Time.at(raw_diff_time).utc.strftime("%H:%M:%S")
    puts "Run time => ".blue + "#{run_time}".yellow + " h/m/s".blue
  end
    
  Then 'I confirm that sub-user sees "Make full use of ParkEdge with a Premium Subscription." message' do
    current_path.should == ("/subscription_info")
    page.should have_content("Make full use of ParkEdge with a Premium Subscription")
    page.should have_content("If your organization upgrades to a Premium ParkEdge Subscription, you can")
    page.should have_content("Set availability of your parking spots")
    page.should have_content("Advertise")
    page.should have_content("Set up event reservations")
  end  
    
    
  end











  
  
  
  
  
end



