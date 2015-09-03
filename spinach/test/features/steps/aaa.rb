class TestingGarageApiParkedgeAndParker2 < Spinach::FeatureSteps
  feature 'Testing Garage API, ParkEdge and Parker2'
  
  Then 'I cleanup' do
    page.cleanup!
  end

  Given 'I navigate to ParkEdge' do
    visit "http://www.monster.com/"
    #visit "http://garage-portal-staging.streetline.com/"
    #visit "http://garage-portal.streetline.com/"
    sleep 1
    
    if current_url.include?("dev-plat") == true
      $environment = "http://garage-api-dev-plat.streetline.com/"
      $parker2_env = "-dev-plat"
      env =  "DEV-PLAT"
    elsif current_url.include?("staging") == true
      $environment = "http://garage-api-staging.streetline.com/"
      $parker2_env = "-staging"
      env = "STAGING"
    elsif urrent_url.include?("garage-portal.streetline.com") == true
      $environment = "http://garage-api.streetline.com/"
      $parker2_env = ""
      env = "PRODUCTION"
    end
     
    puts "Test is performing against ".green + "#{env} ".blue + "environment".green
  end

  And 'I click on "Login" button' do
    page.find("#btn_login").click
    sleep 1
  end
  
  Then 'I login' do
    page.find('#owner_login').set(true)
    sleep 1
    using_wait_time(5) do
      page.should have_content("Forgot your password?")
    end
    
    fill_in("username", :with=> "test_user")
    fill_in("password", :with=> "please")
    page.click_on("Login")
    
    using_wait_time(5) do
      page.find("#map_details").should be_visible
    end
  end

  And 'I select "Walgreens Lot" test lot' do
    using_wait_time(5) do
      page.should have_css(".btn_location-info")
    end
    page.find(:css, ".btn_location-info", :text=> "Walgreens Lot").click
    #page.find(:css, ".btn_location-info", :text=> "Facebook Test").click
    
    sleep 1
  end

  Then 'I find "Total Spaces" capacity' do
    #sleep 1
    $grand_total_spaces = page.find('#facility_spaces').value.to_f
    puts "Lot Total Capacity => #{$grand_total_spaces}".blue
    
    if $grand_total_spaces <= 0 
      puts "Lot Total Capacity is #{$grand_total_spaces}. Please provide valid values for lot capaciyt!".red
      exit
    end
    
  end
    
  Then 'I click "Edit This Facility" button' do
    page.find("#btn_edit").click
    sleep 1
    using_wait_time(10) do
      page.should have_content("Required Fields")
    end
  end

  And 'I find LOOKUP_CODE' do
    $lookup_code = page.find("#facility_lookup_code").value
    puts "Lookup_Code => #{$lookup_code}".blue
  end

  Then 'I find selected "Calculated Type"' do
    $facility_calculated_type = page.find('#facility_calculated_type').value
    
    if $facility_calculated_type == ""
      puts "Calculated Type is not selected".blue
    else
      puts "Calculated Type => #{$facility_calculated_type}".blue
    end
    
    #puts "Calculated Type => #{$facility_calculated_type}".blue
  end

  And 'I find "Handicap" capacity' do
    $handicap_capacity = page.find("#facility_handicap_spaces").value.to_f
  end
  
  Then 'I find "Electric" capacity' do
    $electric_capacity = page.find("#facility_electric_spaces").value.to_f
  end
  
  And 'I find "Oversize" capacity' do
    $oversize_capacity = page.find("#facility_oversize_spaces").value.to_f
  end
  
  Then 'I find "Monthly" capacity' do
    $monthly_capacity = page.find("#facility_monthly_spaces").value.to_f
  end
  
  And 'I find "Student" capacity' do
    $student_capacity = page.find("#facility_student_spaces").value.to_f
  end

  And 'I change "Student" capacity based on capacity calculations' do
    $calculated_students_capacity = $grand_total_spaces - ($handicap_capacity + $electric_capacity + $oversize_capacity + $monthly_capacity).to_f.round()
    fill_in("facility_student_spaces", :with => $calculated_students_capacity)
    
    $min_lot_total_capacity = ($handicap_capacity + $electric_capacity + $oversize_capacity + $monthly_capacity).round()
    $max_lot_total_capacity = $calculated_students_capacity.to_f.round()
  end
    
  And 'I select "STUDENT" calculated type, if needed' do
    if $facility_calculated_type == 'STUDENT'
      #puts "Calculated type is STUDENT"
    else
      page.find('#facility_calculated_type').select('STUDENT')
    end
  end

  Then 'I click on "Save" button' do
    page.find("#btn_edit_submit").click
    sleep 2
  end

  And 'I find Auth Key' do
    page.click_on("Availability")
    sleep 1
    auth_key = page.find(".box p.top1em.bold").text
    auth_key = auth_key.gsub("#{$environment}publish/states?auth_key=", "")
    $single_access_token = auth_key.gsub("&lookup_code=#{$lookup_code}&availability=<NONE|SOME|LOTS>", "")
    puts "Auth Key ==> #{$single_access_token}".blue
  end

  Then 'I select "Real Time" publishing data' do
    page.find("#track_feed").click
  end
  
  And 'I click on "Publish" button' do
    page.click_on("Publish")
    sleep 1
  end
  
  Then 'I find facility ID' do
    parker2_key = `curl -sS -GET "http://parker2#{$parker2_env}.streetline.com/api/customer_auth_string/public.txt"`
    $key = parker2_key.gsub("\n", "")
    puts "Parker2 key => #{$key}".blue 
    sleep 1
    curlBody = "curl -sS -GET 'http://parker2#{$parker2_env}.streetline.com/api/#{$key}/availability/f4/sanmateo/availability.json'"
    
    parker2_call_response = `#{curlBody}`
    parsed_json = JSON.parse(parker2_call_response)
    
    facility_id = parsed_json["availability"]["parkingAggregateIds"][5].gsub("pf", "")
    $facility_id_global = facility_id.gsub("_STUDENT", "")
    puts "Facility ID => #{$facility_id_global}".blue
  end
  
  When 'I randomize calculated type availability' do
    $randomized_calculated_type_availability = rand($min_lot_total_capacity..$max_lot_total_capacity - ($handicap_capacity + $electric_capacity + $oversize_capacity + $monthly_capacity).to_f.round()).to_f.round()
      
    puts "Randomized calculated type availability ==> #{$randomized_calculated_type_availability}".blue
  end
  

  When 'I deselect "Calculated Type"' do
    page.find('#facility_calculated_type').select('')
    sleep 1
  end
   
And 'I do counts CURL call' do
    
    general_availability = rand(1..5)
    electric_availability = rand(1..5)
    handicapped_availability = rand(1..5)
    oversized_availability = rand(1..5)
    monthly_availability = rand(1..5)
    student_availability = $randomized_calculated_type_availability
    
    curl_call = `curl -sS -POST "#{$environment}publish/counts?auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}&availability=#{general_availability}&ev=#{electric_availability}&hcp=#{handicapped_availability}&oversized=#{oversized_availability}&monthly=#{monthly_availability}&student=#{student_availability}"`
    
      sleep 1
      
      if curl_call.include?("OK")
        puts "\t * Publish counts call passed".green
      else
        puts "Publish counts call  failed".red
        puts "curl -sS -POST '#{$environment}publish/counts?auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}&availability=#{general_availability}&ev=#{electric_availability}&hcp=#{handicapped_availability}&oversized=#{oversized_availability}&monthly=#{monthly_availability}&student=#{student_availability}'".yellow
        exit
      end
      
    sleep 3
    
    facilities_call_response = `curl -sS -GET "#{$environment}facilities/17418/counts.json?deployment_id=36"`
    parsed_json = JSON.parse(facilities_call_response)
    #puts parsed_json
    
    sleep 3
    
    $general_check = parsed_json["GENERAL"].to_f.round()
    $electric_check = parsed_json["ELECTRIC"].to_f.round()
    $handicapped_check = parsed_json["HANDICAPPED"].to_f.round()
    $oversized_check = parsed_json["OVERSIZED"].to_f.round()
    $monthly_check = parsed_json["MONTHLY"].to_f.round()
    $sudent_check = parsed_json["STUDENT"].to_f.round()
    
    if $general_check == general_availability and student_availability == $sudent_check and $electric_check == electric_availability and $handicapped_check == handicapped_availability and $oversized_check == oversized_availability and $monthly_check == monthly_availability
      puts "\t * Facilities counts call passed".green
    else
      puts "Oops! Facilities counts call failed!".red
      puts facilities_call_response.yellow
      exit
    end  
  end
  
  
  Then 'I calculate selected type capacity' do
    $selected_type_capacity = $grand_total_spaces - ($general_check + $electric_check + $handicapped_check + $oversized_check + $monthly_check).round()
    #puts "=======>>>>>> #{$selected_type_capacity}"
  end
  
  Then 'I do lot_totla CURL call' do 
    lot_total_curl_body = "curl -sS -POST  '#{$environment}publish/lot_total?count=#{$randomized_calculated_type_availability}&auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}'"
    lot_total_curl_result = (`#{lot_total_curl_body}`)

    lot_total_curl_result.should include("OK")
  end
  
  
  Then 'I verify that JSON has expected number of calculated spaces' do
    
    $count_of_occupied_spaces_without_calculated = ($general_check + $electric_check + $handicapped_check + $oversized_check + $monthly_check).round()
    $count_of_occ_student_parking = ($randomized_calculated_type_availability - $count_of_occupied_spaces_without_calculated).round()
    
    $lot_total_count_less_then_zero = ($count_of_occupied_spaces_without_calculated - 1).round()
    $lot_total_student_check_cilling_to_capacity = ($grand_total_spaces + 1).round()
    
    if $count_of_occ_student_parking <= 0
      $count_of_occ_student_parking = 0
    end
    
    #puts "curl -sS -GET '#{$environment}facilities/17418/counts.json?deployment_id=36'".red
    facilities_call_response = `curl -sS -GET "#{$environment}facilities/17418/counts.json?deployment_id=36"`
    parsed_json = JSON.parse(facilities_call_response)
    parsed_json
    
    $lot_total_student_check = (parsed_json["STUDENT"].to_f).round()
    
    $lot_total_student_check.should == $count_of_occ_student_parking
    puts "#{$lot_total_student_check} should equal #{$count_of_occ_student_parking}".blue
  end
  
  And 'I verify that Parker2 JSON has expected number of calculated spaces' do
    parker2_key = `curl -sS "http://parker2#{$parker2_env}.streetline.com/api/customer_auth_string/public.txt"`
    $key = parker2_key.gsub("\n", "")
    puts "Parker2 key => #{$key}".blue 
    sleep 2
    
    curlBody = "curl -sS -GET 'http://parker2#{$parker2_env}.streetline.com/api/#{$key}/availability/f4/sanmateo/availability.json'"
    sleep 2
    parker2_call_response = `#{curlBody}`
    parsed_json = JSON.parse(parker2_call_response)
    
    parsed_json["availability"]["parkingAggregateIds"][5].should include("_STUDENT") # Making sure that JSON has expected order of spaces
    
    parker2_json = parsed_json["availability"]["parkingAggregateAvailabilityCounts"]
    parker2_student = (parker2_json[5].to_f).round()
  
    puts "#{$lot_total_student_check} should equal #{parker2_student}".blue
    $lot_total_student_check.should == parker2_student
  end
  
  When 'I deselect "Calculated Type"' do
    page.find('#facility_calculated_type').select('')
    sleep 1
  end
  
  And 'I post availability that is greater than capacity' do
    curl_post_greater_than_capacity = "curl -sS -POST  '#{$environment}publish/lot_total?count=#{$lot_total_student_check_cilling_to_capacity}&auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}'"
    
    lot_total_curl_result = (`#{curl_post_greater_than_capacity}`)
    lot_total_curl_result.should include("OK")
  end

  Then 'I verify that garage API JSON has expected number of calculated spaces' do
    facilities_call_response = `curl -sS -GET "#{$environment}facilities/17418/counts.json?deployment_id=36"`
    parsed_json = JSON.parse(facilities_call_response)    
    parsed_json_student_check = (parsed_json["STUDENT"].to_f).round()
    
    parsed_json_student_check.should == $selected_type_capacity
    puts "#{parsed_json_student_check} should equal #{$selected_type_capacity}".blue
  end
  
  And 'I verify that Parker2 JSON has expected number from GAPI' do
    parker2_key = `curl -sS "http://parker2#{$parker2_env}.streetline.com/api/customer_auth_string/public.txt"`
    $key = parker2_key.gsub("\n", "")
    puts "Parker2 key => #{$key}".blue 
    sleep 2
    
    curlBody = "curl -sS -GET 'http://parker2#{$parker2_env}.streetline.com/api/#{$key}/availability/f4/sanmateo/availability.json'"
    sleep 2
    parker2_call_response = `#{curlBody}`
    parsed_json = JSON.parse(parker2_call_response)
    
    parsed_json["availability"]["parkingAggregateIds"][5].should include("_STUDENT") # Making sure that JSON has expected order of spaces
    
    parker2_json = parsed_json["availability"]["parkingAggregateAvailabilityCounts"]
    parker2_student = (parker2_json[5].to_f).round()
  
    puts "#{$selected_type_capacity} should equal #{parker2_student}".blue
    $selected_type_capacity.should == parker2_student
  end
  
  And 'I post availability that is less than zero' do
    #puts $count_of_occupied_spaces_without_calculated
    #puts $lot_total_count_less_then_zero
    
    lot_total_curl_body = "curl -sS -POST  '#{$environment}publish/lot_total?count=#{$lot_total_count_less_then_zero}&auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}'"
    lot_total_curl_result = (`#{lot_total_curl_body}`)
    
    lot_total_curl_result.should include("OK")
    sleep 3
  end
    
  And 'I verify that JSON returs zero' do
    sleep 10
    facilities_call_response = `curl -sS -GET "#{$environment}facilities/17418/counts.json?deployment_id=36"`
    parsed_json = JSON.parse(facilities_call_response)
    
    $lot_total_student_check_zero = (parsed_json["STUDENT"].to_f).round()
    
    if $lot_total_student_check_zero != 0
      puts parsed_json
    end
    
    $lot_total_student_check_zero.should == 0
    puts "#{$lot_total_student_check_zero} should equal 0".blue
    sleep 1
  end
  
  Then 'I verify that Parker2 JSON returs zero' do
    parker2_key = `curl -sS "http://parker2#{$parker2_env}.streetline.com/api/customer_auth_string/public.txt"`
    $key = parker2_key.gsub("\n", "")
    #puts "Parker2 key => #{$key}".blue 
    sleep 2
    
    curlBody = "curl -sS -GET 'http://parker2#{$parker2_env}.streetline.com/api/#{$key}/availability/f4/sanmateo/availability.json'"
    sleep 2
    parker2_call_response = `#{curlBody}`
    parsed_json = JSON.parse(parker2_call_response)
    
    parsed_json["availability"]["parkingAggregateIds"][5].should include("_STUDENT") # Making sure that JSON has expected order of spaces
    
    parker2_json = parsed_json["availability"]["parkingAggregateAvailabilityCounts"]
    parker2_student = (parker2_json[5].to_f).round()
  
    puts "#{$lot_total_student_check_zero} should equal #{parker2_student}".blue
    $lot_total_student_check_zero.should == parker2_student
  end
  
  Then 'I post availability that is equal to zero' do
    lot_total_curl_body = "curl -sS -POST  '#{$environment}publish/lot_total?count=0&auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}'"
    lot_total_curl_result = (`#{lot_total_curl_body}`)

    lot_total_curl_result.should include("OK")
  end
  
  Then 'I post negative value for availability' do
    sleep 5
    lot_total_curl_body = "curl -sS -POST  '#{$environment}publish/lot_total?count=-10&auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}'"
    lot_total_curl_result = (`#{lot_total_curl_body}`)

    lot_total_curl_result.should include("OK")
  end
  
  When 'I do lot_totla CURL call I should have "Facility calculated type missing" response' do 
    lot_total_curl_body = "curl -sS -POST  '#{$environment}publish/lot_total?count=#{$randomized_calculated_type_availability}&auth_key=#{$single_access_token}&lookup_code=#{$lookup_code}'"
    lot_total_curl_result = (`#{lot_total_curl_body}`)
    
    lot_total_curl_result.should include("Facility calculated type missin")
  end
  
  And 'I enter original "Total Spaces" capacity' do
    fill_in("facility_spaces", :with => $grand_total_spaces)
  end

  And 'I enter original "Handicap" capacity' do
    fill_in("facility_handicap_spaces", :with => $handicap_capacity)
  end
  
  And 'I enter original "Electric" capacity' do
    fill_in("facility_electric_spaces", :with => $electric_capacity)
  end
  
  And 'I enter original "Oversize" capacity' do
    fill_in("facility_oversize_spaces", :with => $oversize_capacity)
  end
  
  And 'I enter original "Monthly" capacity' do
    fill_in("facility_monthly_spaces", :with => $monthly_capacity)
  end
  
    
  And 'I enter original "Student" capacity' do
    fill_in("facility_student_spaces", :with => $student_capacity)
  end
  
  And 'I change selected calulated type to original' do
    #fill_in("facility_calculated_type", :with => $facility_calculated_type)
    page.find('#facility_calculated_type').select($facility_calculated_type)
    sleep 5
  end
end