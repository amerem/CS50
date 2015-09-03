class TestingParkedgeBasicFunctionalities < Spinach::FeatureSteps
  feature 'Testing ParkEdge basic functionalities'
  
  Then 'I cleanup' do
    page.cleanup!
  end
  
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
  
  Given 'I navigate to ParkEdge login page' do
    #visit "http://localhost:3000/"
    #visit "http://garage-portal-dev-plat.streetline.com/"
    visit "http://garage-portal-staging.streetline.com/"
    #visit "http://parkedge.streetline.com"
    
    $home_page = current_url
    $facility_name = "sln_qa_facility_test"
    
    
    if current_url.include?("-dev-plat")
      puts "Running test against ".blue + "DEV-PLAT".yellow + " environment.".blue
      
    elsif current_url.include?("-staging")
      puts "Running test against ".blue + "STAGING".yellow + " environment.".blue
      
    elsif current_url.include?("parkedge.streetline.com")
      puts "Running test against ".blue + "PRODUCTIONT".yellow + " environment.".blue
      
    else 
      puts "Running test against ".blue + "#{$home_page}".yellow + " environment.".blue
    end
    
    version_raw = page.find("div.footer p:last").text
    version_gsub1 = version_raw.gsub(/[^0-9A-Za-z.]/, '')
    version_gsub2 = version_gsub1.gsub("2015StreetlineInc.AllRightsReserved.Streetline.com", "")
    puts "Test is performing against ".blue + "#{version_gsub2}".yellow + " version.".blue
  end

  Then 'I click on "Customer Login" button' do
    page.find(".btn.btn-blue").click
  end

  And 'I verify that "Login" page loads' do
    sleep 5
    page.find("#password").should be_visible
    page.find("#btn_login").should be_visible
    page.find("#btn_register").should be_visible
    page.find("#btn_learn").should be_visible
    page.find("#btn_cancel").should be_visible
    page.find("#btn_help").should be_visible
    page.find(".topthirdem .grey").should be_visible
  end

  Then 'I enter user name' do
    $user_name = "sln_qa"
    fill_in("username", :with => $user_name)
  end

  Then 'I enter password' do
    fill_in("password", :with => "please")
  end
  
  When 'I uncheck "I am the facility owner" check-box' do
    page.find(:css, "#owner_login").set(false)
  end
  
  And 'I check "I am the facility owner" checkbox' do
    page.find(:css, "#owner_login").set(true)
  end
  
  Then 'I verify that "Invalid user name or password." message appears' do
    page.should have_content("Invalid user name or password.")
  end
  
  Then 'I click on "Login" button' do
    page.find(".btn-blue.left").click
  end

  And 'I click on "Locations" tab' do
    page.click_on("Locations")
  end

  Then 'I verify that "Locations" page shown as expected' do
    page.find(".menu").should be_visible
    page.find("#map_div").should be_visible
    page.find("#address").should be_visible
    page.find("#map_details").should be_visible
    page.find("#btn_add-location").should be_visible
    page.find("#btn_adjust_location").should be_visible
  end

  And 'I click on "Rates" tab' do
    sleep 3
    page.click_on("Rates")
  end

  Then 'I verify that "Rates" page appears as expected' do
    page.find(".menu").should be_visible
    using_wait_time(10) do
      page.find("#add_flat_policy").should be_visible
    end
    page.find("#add_flat_policy").should be_visible
    page.find("#add_metered_policy").should be_visible
    page.find("#add_schedule_policy").should be_visible
  end

  And 'I click on "Availability" tab on left nav' do
    page.click_on("Availability")
  end

  Then 'I verify that "Availability" page appears as expected' do
    sleep 2
    page.find(".menu").should be_visible
    page.find("#select_box_for_garage").should be_visible
    page.find(".btn-teal.right1em").should be_visible

    page.find("#track_none").should be_visible
    page.find("#track_feed").should be_visible
    page.find("#track_manual").should be_visible
    page.find("#track_counters").should be_visible
  end

  And 'I click on "Reservations" tab on left nav' do
    page.click_on("Reservations")
  end

  Then 'I verify that "Reservations" page appears as expected' do
    sleep 3
    page.find(".menu").should be_visible
    page.find("#facility_id").should be_visible
    page.find("#datepicker .ui-helper-clearfix.ui-corner-all").should be_visible
    page.find("#event_details").should be_visible
    page.find("#event_accept_terms").should be_visible
    #page.find(".btn-blue.btn-lg").should be_visible
    page.find("#event_total_spaces").should be_visible
    page.find("#event_cost").should be_visible
    page.find("#event_total_spaces").should be_visible
    page.find("#event_cost").should be_visible
  end

  And 'I click on "Promotions" tab on left nav' do
    page.click_on("Promotions")
  end

  Then 'I verify that "Promotions" page appears as expected' do
    page.find(".menu").should be_visible
    page.find(".content.locations").should be_visible
    page.find("#btn_new").should be_visible
    page.find("#btn_edit_selected").should be_visible
    page.find("#btn_view_selected").should be_visible
    page.find("#btn_report").should be_visible
  end

  And 'I click on "Account" tab on left nav' do
    page.click_on("Account")
  end

  Then 'I verify that "Account" page appears as expected' do
    page.find(".menu").should be_visible
    page.find(".content.users").should be_visible
    page.find("#btn_user-contact").should be_visible
    page.find("#btn_password-reset").should be_visible
    page.find("#tos_account").should be_visible
    page.find("#tos_facilities").should be_visible
    page.find("#tos_reservations").should be_visible
    page.find("#user_select").should be_visible
    page.find("#btn_user-add").should be_visible
    page.find("#btn_user-info").should be_visible
    
    page.find("#btn_user-edit").should be_visible
    page.find("#btn_user-delete").should be_visible
    page.find("#btn_reset-token").should be_visible
    page.find(".field-col.left:last").should be_visible
    page.should have_content("Auth Key :")
  end

  And 'I click on "Administration" tab on left nav' do
    page.click_on("Administration")
  end

  Then 'I verify that "Administration" page appears as expected' do
    page.find(".menu").should be_visible
    page.find(".locations").should be_visible
    page.find(".admin").should be_visible
    page.find(".btn-blue.right").should be_visible
    page.find("#search_value").should be_visible
    page.should have_css(".btn-blue.left", :count => 4)
  end

  Then 'I click on "logout" button' do
    sleep 2
    page.find("#btn_logout").click
  end

  And 'I verify that I was logged out of the account' do
    sleep 2
    page.should have_content("Signed out successfully.")
    current_url.should == $home_page
  end
  
  When 'I count existing facilities under this user' do
    sleep 5
    using_wait_time(5) do
      page.find("#map_details").should be_visible
    end
    $facilities_count = page.all("#locations .btn_location-info").count
  end
  
  Then 'I click on "Add New Facility" button' do
    sleep 5
    using_wait_time(5) do
      page.find("#btn_add-location").should be_visible
    end
    page.find("#btn_add-location").click
  end
  
  And 'I enter name' do
    sleep 5
    #$facility_name = "sln_qa_facility_test"
    fill_in("facility_name", :with => $facility_name)
  end
  
  Then 'I ckeck "Private" checkbox' do
    page.find(:css, "#facility_facility_facility_types_attributes_4__destroy").set(true)
  end
  
  And 'I provide total capacity in "General Spaces" text field' do
    fill_in("facility_spaces", :with => "100")
  end
  
  Then 'I enter student capacity' do
    fill_in("facility_facility_space_types_attributes_8_count", :with => "20")
  end
  
  And 'I enter operator name' do
    fill_in("facility_operator", :with => "SLN_QA_TEST_NAME")
  end
  
  And 'I provide dddress' do
    #fill_in("facility_address1", :with => "393 Vintage Park Drive")
    fill_in("facility_address1", :with => "200 Root Ave")
  end
  
  Then 'I enter city' do
    #fill_in("facility_city", :with => "Foster City")
    fill_in("facility_city", :with => "Friant")
  end
  
  Then 'I enter state' do
    fill_in("facility_state_prov_region", :with => "California")
  end
  
  Then 'I enter postal code' do
    #fill_in("facility_postal_code", :with => "94404")
    fill_in("facility_postal_code", :with => "93626")
  end
  
  And 'I select country' do
    page.select("United States", :from => "facility_country_id")
  end
  
  Then 'I enter lookup code' do
    lookup_code = "sln_qa_lookaup_code_#{Time.now.to_i}"
    fill_in("facility_lookup_code", :with => lookup_code)
  end
  
  And 'I provide phone number' do
    fill_in("facility_phone", :with => "(650)242-3400")
  end
  
  Then 'I ckeck "I agree to the Terms of Use" check-box' do
    sleep 2
    using_wait_time(15) do
      page.should have_content("Required Fields")
    end
    page.find(:css, "#agree_to_terms").set(true)
  end
  
  And 'I unckeck "I agree to the Terms of Use" check-box' do
    sleep 1
    page.find(:css, "#agree_to_terms").set(false)
  end
  
  And 'I click on "Add" button' do
    page.find("#btn_edit_submit").click
    sleep 5
  end
  
  Then 'I verify that facility was created' do
    sleep 5
    using_wait_time(10) do
      page.find("#locations").should be_visible
    end
    facilities_count_check = page.all("#locations .btn_location-info").count
    
    page.should have_content($facility_name)
    facilities_count_check.should == $facilities_count + 1
  end
  
  Then 'I verify that appropriate message(s) appears' do
    #page.find(:css, ".errors li", :text => "Please choose at least one facility type.", :visible => true)
    page.find(:css, ".errors li", :text => "Please choose at least one facility type.").should be_visible
    page.find(:css, ".errors li", :text => "City can't be blank").should be_visible
    page.find(:css, ".errors li", :text => "Address1 can't be blank").should be_visible
    page.find(:css, ".errors li", :text => "State prov region can't be blank").should be_visible
    page.find(:css, ".errors li", :text => "Postal code can't be blank").should be_visible
  end
  
  And 'I click on "Cancel" button' do
    page.click_on("Cancel")
    sleep 2
  end
  
  And 'I make sure that QA test facility does not exist' do
    sleep 3
    facility_check = page.has_content?($facility_name)
    
    if facility_check == true
      page.click_on($facility_name)
      sleep 3
      page.find("#btn_edit").click
      sleep 3
      using_wait_time(10) do
        page.should have_content("Delete")
      end
      page.click_on("Delete")
      page.driver.browser.switch_to.alert.accept
      
      puts "QA TEST facility ".yellow + "#{$facility_name}".red + " has been deleted!".yellow
    else
      #do nothing
    end
  end
  
  And 'I delete "sln_qa_facility_test" facility' do
    sleep 2
    page.should have_content($facility_name)
    page.click_on($facility_name)
    sleep 2
    page.find("#btn_edit").click
    sleep 3
    using_wait_time(10) do
      page.should have_content("Delete")
    end
    page.click_on("Delete")
    page.driver.browser.switch_to.alert.accept
  end
  
  Then 'I verify that facility has been deleted' do
    sleep 2
    using_wait_time(10) do
      page.find("#locations").should be_visible
    end
    
    page.should_not have_content($facility_name)
    facilities_count_check = page.all("#locations .btn_location-info").count
    
    facilities_count_check.should == $facilities_count
  end
  
  Then 'I select facility' do
    sleep 5
    using_wait_time(10) do
      page.find(".facility_name").should be_visible
    end
    #page.find(:css, "locations a", :text => $facility_name).click
    page.find("#locations a").click
    #page.click_on($facility_name + " - as owner ")
  end
  
  And 'I find facility default name' do
    $default_facility_name = page.find("h2.insp").text
    puts "Default facility name => ".blue + "#{$default_facility_name}".yellow
  end
  
  Then 'I click on "Edit This Facility (admin)" button' do
    page.find("#btn_edit").click
    sleep 5
  end
  
  And 'I change facility name' do
    sleep 2
    using_wait_time(10) do
      page.find("#facility_name").should be_visible  
    end
    
    $updated_facility_name = "#{$default_facility_name} QA"
    #puts page.find("#facility_name").value
    fill_in("facility_name", :with => $updated_facility_name)
  end
  
  Then 'I click on "Save" button' do
    page.click_on("Save")
    sleep 1
  end
  
  And 'I verify that facility name has been updated' do
    sleep 2
    page.should have_content($updated_facility_name)
    $updated_facility_name.should == page.find("h2.insp").text
  end
  
  Then 'I change name to default' do
    sleep 2
    using_wait_time(10) do
      page.find("#facility_name").should be_visible  
    end
    
    #puts page.find("#facility_name").value
    fill_in("facility_name", :with => $default_facility_name)
    sleep 2
  end
  
  And 'I verify that facility name has been changed to original' do
    sleep 5
    page.should have_content($default_facility_name)
    $default_facility_name.should == page.find("h2.insp").text
    #puts "#{$default_facility_name} == " + page.find("h2.insp").text
  end
  
  Then 'I find original total spaces on "Locations" page' do
    $original_total_spaces_on_locations = page.find("h3.insp:last").text.tr('A-Za-z: ', "")
  end
  
  And 'I memorize capacity of general spaces of facility on "Edit" page' do
    sleep 2
    $original_general_spaces_on_edit_page = page.find("#facility_spaces").value.tr("A-Za-z: ", "")
  end
  
  And 'I click on "More" link' do
    page.click_on("More")
    sleep 2
  end
    
  Then 'I find number of general spaces in popup window' do
    $original_general_spaces_on_popup = page.find("#spaces p").text.tr("A-Za-z: ", "")
  end
  
  And 'I close popup window by clicking on "Cancel" button' do
    page.click_on("Cancel")
    sleep 1
  end
  
  Then 'I verify that number of spaces equal across all pages' do
    $original_total_spaces_on_locations.should == $original_general_spaces_on_popup
    $original_general_spaces_on_popup.should == $original_general_spaces_on_edit_page
    $original_total_spaces_on_locations.should == $original_general_spaces_on_edit_page
  end
  
  And 'I change capacity of the lot' do
    $updated_lot_capacity = rand(50..200).to_s
    fill_in("facility_spaces", :with => $updated_lot_capacity)
  end
  
  And 'I verify that lot capacity has been updated as expected' do
    $updated_lot_capacity.should == page.find("#facility_spaces").value.tr("A-Za-z: ", "")
  end
  
  Then 'I verify that lot capacity has been updated on "Locations" page' do
    $updated_lot_capacity.should == page.find("h3.insp:last").text.tr('A-Za-z: ', "")
  end
  
  Then 'I verify that lot capacity has been updated on popup window' do
    $updated_lot_capacity.should == page.find("#spaces p").text.tr("A-Za-z: ", "")
  end
  
  Then 'I select "sln_qa_facility_test" facility from "Facility" drop-down menu' do
    select($facility_name, :from => "select_box_for_garage")
  end
  
  And 'I click on "Add a Flat Fee Policy" button' do
    page.find("#add_flat_policy").click
    sleep 5
  end
  
  And 'I click on "Add" button' do
    page.click_on("Add")
    sleep 2
  end
  
  And 'I verify that expected warning message(s) appears' do
    page.should have_content("Name can't be blank")
    page.should have_content("Rate is not a number")
    page.should have_content("Please enter a time period for at least one day.")
  end
  
  Then 'click "Cancel" link' do
    page.click_on("Cancel")
    sleep 1
  end
  
  Then 'I provide "Flat Fee Policy" name' do
    $sln_qa_test_policy_name = "sln_qa_test_policy"
    fill_in("flat_fee_policy_name", :with => $sln_qa_test_policy_name)
  end
  
  And 'I enter rate' do
    fill_in("flat_fee_policy_rate", :with => "1")
  end
  
  Then 'I select max stay' do
    select("02", :from => "flat_fee_policy_max_stay_in_hours_and_minutes_4i")
  end
  
  When 'select effective days' do
    sleep 1
    select("01", :from => "flat_fee_policy_sun_start_4i")
    select("05", :from => "flat_fee_policy_sun_end_4i")
    
    select("09", :from => "flat_fee_policy_mon_start_4i")
    select("02", :from => "flat_fee_policy_mon_end_4i")
  end
  
  Then 'I provide restriction information' do
    $rates_info = "No parking within ten (10) feet of a fire hydrant."
    fill_in("flat_fee_policy_restrictions", :with => $rates_info)
  end
  
  Then 'I verify that policy rate has been created' do
    page.should have_content($sln_qa_test_policy_name)
    page.all(".btn.btn-toggle-off").count.should >= 1
  end

  Then 'I find information in currency rate section and verify that expected info shown there' do
    sleep 1
    current_rates_section_text = page.find(".rate_policy").text
    current_rates_section_text.should have_content($rates_info)
    current_rates_section_text.should have_content($sln_qa_test_policy_name)
  end
  
  And 'I verify that rate with extend beyond midnight hour has been created' do
    page.should have_content("Mon: 9:00 am - 2:00 am")
    page.should have_content("Sun: 1:00 am - 5:00 am")
    page.should have_content("Maximum Stay: 2 hours")
    page.should have_content("$1.00")
  end
  
    
  And 'I make sure that at least one rate policy' do
    page.should have_content($sln_qa_test_policy_name)
    page.all(".btn.btn-toggle-off").count.should >= 1
    $rate_count = page.all(".btn.btn-toggle-off").count
  end
    
  Then 'I click on "Edit" link for policy' do
    page.find("a.btn_rate-edit").click
    sleep 2
  end
  
  And 'I edit policy' do
    $updated_sln_qa_test_policy_name = "sln_qa_test_policy_updated"
    fill_in("flat_fee_policy_name", :with => $updated_sln_qa_test_policy_name)
    
    $updated_rates_info = "No parking within four (4) feet of a driveway"
    fill_in("flat_fee_policy_restrictions", :with => $updated_rates_info)
    
    select("", :from => "flat_fee_policy_sun_start_4i")
    select("", :from => "flat_fee_policy_sun_end_4i")
    select("01", :from => "flat_fee_policy_mon_start_4i")
    select("03", :from => "flat_fee_policy_mon_end_4i")
  end
  
  Then 'I save it' do
    page.find(".btn.btn-blue").click
    sleep 2
  end
  
  And 'I find information in currency rate section' do
    $updated_current_rates_section_text = page.find(".rate_policy").text
  end
  
  Then 'I verify that policy has been changed' do
    sleep 1
    $updated_current_rates_section_text.should have_content($updated_sln_qa_test_policy_name)
    $updated_current_rates_section_text.should have_content($updated_rates_info)
  end
  
  And 'I click on "Delete" link' do
    page.click_on("Delete")
    sleep 1
  end
  
  Then 'I click on "OK" button on "Are you sure?" popup' do
    page.driver.browser.switch_to.alert.accept
    sleep 1
  end
    
  And 'I verify that I delete rate successfully' do
    sleep 3
    page.should_not have_content($sln_qa_test_policy_name)
    page.should_not have_content($updated_sln_qa_test_policy_name)
    page.all(".btn.btn-toggle-off").count.should == $rate_count - 1
  end
  
  And 'I click "Add a Time Period Policy"' do
    page.find("#add_metered_policy").click
    sleep 2
  end
  
  Then 'I click on "Add" button to add "Time Period Policy"' do
    page.click_on("Add")
    sleep 1
  end
  
  And 'I verify that expected messages shows up on the page' do
    page.should_not have_content("Time period timeslots rate is not a number") # This filed is not required anymore
    page.should_not have_content("Time period timeslots duration can't be blank") # This filed is not required anymore
    page.should_not have_content("Time period timeslots is invalid") # This filed is not required anymore
    page.should have_content("Name can't be blank")
    page.should have_content("Please check at least one day.")
  end
  
  Then 'I close popup window by clicking on "Cancel" link' do
    page.click_on("Cancel")
    sleep 1
  end
  
  
  Then 'I verify that "Add Time Period Policy" page loads' do
    page.should have_content("Add Time Period Policy")
    sleep 5
  end
    
  And 'I provide name for "Time Period Policy"' do
    fill_in("time_period_policy_name", :with=> $sln_qa_test_policy_name)
  end
    
  Then 'I provide "Fees Min"' do
    fill_in("time_period_policy_min_price", :with => "1.0")
  end
    
  And 'I provide "Fees Max"' do
    fill_in("time_period_policy_max_price", :with => "2.0")
  end
  
  Then 'I select start time' do
    page.find('#time_period_policy_starts_at_4i').find('option[2]').select_option
  end
    
  And 'I select end time' do
    page.find('#time_period_policy_ends_at_4i').find('option[3]').select_option
  end
  
  Then 'I select effective days' do
    #page.find(:css, "#time_period_policy_is_sunday").set(true)
    page.find(:css, "#time_period_policy_is_monday").set(true)
    #page.find(:css, "#time_period_policy_is_tuesday").set(true)
    #page.find(:css, "#time_period_policy_is_wednesday").set(true)
    #page.find(:css, "#time_period_policy_is_thursday").set(true)
    #page.find(:css, "#time_period_policy_is_friday").set(true)
    #page.find(:css, "#time_period_policy_is_saturday").set(true)
    sleep 1
  end
  
  And 'I choose max stay' do
    page.find('#time_period_policy_max_stay_in_hours_and_minutes_4i').find('option[3]').select_option
  end
  
  Then 'I fill in "Time Slots" text field' do
    fill_in("time_period_policy_time_period_timeslots_attributes_0_rate", :with => "2")
  end
  
  And 'I choose time from "for every" drop-down menu' do
    page.find("#time_period_policy_time_period_timeslots_attributes_0_duration_4i").find("option[3]").select_option
  end
  
  When 'I type restriction in "Restrictions" text field' do
    fill_in("time_period_policy_restrictions", :with => $rates_info)
  end

  Then 'I change time period policy' do
    $updated_sln_qa_test_policy_name = "sln_qa_test_policy_updated"
    fill_in("time_period_policy_name", :with => $updated_sln_qa_test_policy_name)
    
    $updated_rates_info = "No parking within four (4) feet of a driveway"
    fill_in("time_period_policy_restrictions", :with => $updated_rates_info)
  end
  
  And 'I save my changes' do
    page.click_on("Save")
    sleep 3
  end
  
  And 'I click "Add a Fee Schedule Policy" button' do
    page.find("#add_schedule_policy").click
    sleep 5
  end
  
  When 'I click on "Add" button' do
    page.click_on("Add")
    sleep 3
  end
  
  And 'warning expected messages appears' do
    page.should have_content("Fee schedule timeslots rate is not a number")
    page.should have_content("Fee schedule timeslots duration can't be blank")
    page.should have_content("Fee schedule timeslots is invalid")
    page.should have_content("Name can't be blank")
    page.should have_content("Please check at least one day.")
  end
  
  Then 'I enter ree schedule policy name' do
    sleep 1
    fill_in("fee_schedule_policy_name", :with=> $sln_qa_test_policy_name)
  end
  
  And 'I choose effective days' do
    page.find(:css, "#fee_schedule_policy_is_monday").set(true)
  end
  
  And 'I choose time slots' do
    fill_in("fee_schedule_policy_fee_schedule_timeslots_attributes_0_rate", :with => "1.00")
  end
  
  And 'I chosse time for time slots' do
    page.find('#fee_schedule_policy_fee_schedule_timeslots_attributes_0_duration_4i').find('option[2]').select_option
  end
  
  Then 'I type restrictions' do
    fill_in("fee_schedule_policy_restrictions", :with => $rates_info)
  end
  
  And 'I change Fee Schedule Policy' do
    fill_in("fee_schedule_policy_name", :with => $updated_sln_qa_test_policy_name)
    fill_in("fee_schedule_policy_restrictions", :with => $updated_rates_info)
  end
  
  And 'I select "Untracked" radio button' do
    page.find(:css, "#track_none").set(true)
    sleep 1
  end
  
  Then 'I verify that untracked details page loads as expected' do
    page.should have_content("Not tracking availability")
    page.find("#track_settings_none .top1em").should be_visible
    page.find(".btn-teal.right1em").should be_visible
  end
  
  And 'I select "Manual Estimate" radio button' do
    page.find(:css, "#track_manual").set(true)
    sleep 1
  end
  
  Then 'I verify that "Manual Estimate" details page loads as expected' do
    sleep 1
    page.should have_content("Manual Estimate")
    page.find("#track_settings_manual .top1em").should be_visible
    page.find("#track_settings_manual td").should be_visible
    
    page.find("#facility_availability_manual_state_f").should be_visible
    page.find("#facility_availability_manual_state_s").should be_visible
    page.find("#facility_availability_manual_state_p").should be_visible
    page.find(".btn-teal.right1em").should be_visible
  end
  
  And 'I select "Real-Time" radio button' do
    page.find(:css, "#track_feed").set(true)
    sleep 1
  end
  
  Then 'I verify that Real-Time details page loads as expected' do
    page.should have_content("Publish Real-Time Data from 3rd Party Source or Streetline Sensors")
    page.find("#track_settings_feed .top1em").should be_visible
    page.find(".btn-teal.right1em").should be_visible
  end
  
   And 'I select "Manual Count" radio button' do
    page.find(:css, "#track_counters").set(true)
    sleep 1
  end
   
  Then 'I verify that "Manual Count" details page loads as expected' do
    page.should have_content("Manual Count")
    page.find("#track_settings_counter .top1em").should be_visible
    page.find("#facility_availability_gate_counter").should be_visible
    page.find(".btn-teal.right1em").should be_visible
  end
  
  And 'I fill in "New Availability Count" text field with count' do
    fill_in("facility_availability_gate_counter", :with => "50")
  end
  
  And 'I click on "Publish" button' do
    page.find(".btn-teal.right1em").click
    sleep 2
  end
  
  Then 'I verify that "Updated" message appears' do
    page.should have_content("Updated")
  end
  
  And 'I select "sln_qa_facility_test" facility' do
    sleep 1
    select($facility_name, :from => "facility_id")
    sleep 1
  end
  
  When 'I select day in future' do
    page.find(".ui-icon.ui-icon-circle-triangle-e").click
    sleep 2
    page.find(:css, ".ui-datepicker-calendar td", :text => "15").click
    sleep 2
  end
  
  And 'I enter number of reservable spaces' do
    $reservable_spaces_global = "5"
    fill_in("event_total_spaces", :with => $reservable_spaces_global)
  end
  
  And 'I provide published rate' do
    $published_rate_global = "2"
    fill_in("event_cost", :with => $published_rate_global)
  end
  
  Then 'I check "I have read and agree to the above terms." check-box' do
    page.find(:css, "#event_accept_terms").set(true)
    sleep 1
  end
  
  And 'I uncheck "I have read and agree to the above terms." check-box' do
    page.find(:css, "#event_accept_terms").set(false)
    sleep 1
  end
  
  And 'I click on "Create" button on "Reservations" page' do
    page.find(".btn.btn-lg").click
    sleep 2
  end
  
  And 'I confirm that reservation has been created' do
    sleep 2
    page.find("#reservations h2").should be_visible
    page.find("#selected_date").should be_visible
    page.find("#reservation_date_finder_form").should be_visible
    
    $reservable_spaces_global.should == page.find("#spaces_remaining").text
    
    page.find("#btn_reserve").should be_visible
    page.should have_content("Make a Reservation")
  end
  
  Then 'I confirm that expected error messages appears' do
    page.should have_content("Please fix the following problems")
    page.should have_content("Total spaces is not a number")
    page.should have_content("Cost must be greater than or equal to 1")
    page.should have_content("Accept terms can't be blank")
  end
  
  And 'I edit reservation by changing reservable spaces' do
    $updated_reservable_spaces_global = "4"
    $updated_published_rate_global= "10"
    fill_in("event_total_spaces", :with => $updated_reservable_spaces_global)
    fill_in("event_cost", :with => $updated_published_rate_global)
    sleep 1
  end
  
  And 'I click on "Update" button' do
    page.find(".btn.btn-lg").click
    #sleep 1
  end
  
  Then 'I confirm that reservation has been updated' do
    sleep 1
    
    #page.find("#reservations h2").should be_visible
    page.should have_content("Reservations for")
    page.find("#selected_date").should be_visible
    page.find("#reservation_date_finder_form").should be_visible
    
    $updated_reservable_spaces_global.should == page.find("#spaces_remaining").text
    page.should have_content("The reservation details were updated.")
    page.find("#btn_reserve").should be_visible
    page.should have_content("Make a Reservation")
  end
  
  Then 'I click on "Make a reservation" button' do
    sleep 1
    page.find("#btn_reserve").click
  end
  
  When 'I confirm that "New Reservation" page appears' do
    current_url.include?("reservations?event_id=").should == true
    page.should have_content("New Reservation")
    page.find(".btn.btn-blue").should be_visible
    page.find("#return_to_reservation_management a").should be_visible
  end
  
  Then 'I click on "Continue" button' do
    page.find(".btn.btn-blue").click
  end
  
  And 'I confirm that "New Reservation: Payment Details" page appears as expected' do
    page.should have_content("New Reservation: Payment Details")
    page.find(".btn.btn-blue").should be_visible
    page.find("#return_to_reservation_management a").should be_visible
  end
  
  
  Then 'I provide email address' do
    fill_in("reservation_email", :with => "sln_qa@example.com")
  end
  
  Then 'I provide mobile numbers' do
    fill_in("reservation_mobile_number", :with => "1(555) 555-5555")
  end
  
  Then 'I provide first name' do
    fill_in("reservation_billing_info_attributes_first_name", :with => "Aleks")
  end
  
  Then 'I provide last name' do
    fill_in("reservation_billing_info_attributes_last_name", :with => "Merem")
  end
  
  Then 'I provide billing ZIP code' do
    fill_in("reservation_billing_info_attributes_postal_code", :with => "94404")
  end
  
  Then 'I provide credit card number' do
    fill_in("reservation_billing_info_attributes_credit_card_number", :with => "11111111111111111111")
  end
  
  Then 'I provide expiration date' do
    expiration_year = (Time.now.year + 1).to_s
    select("October", :from => "reservation_billing_info_attributes_credit_card_expiration_month")
    select(expiration_year, :from => "reservation_billing_info_attributes_credit_card_expiration_year")
  end
  
  Then 'I provide CVV' do
    fill_in("reservation_billing_info_attributes_credit_card_verification_value", :with => "555")
  end
  
  And 'I click on "Pay and Reserve" butotn' do
     page.find(".btn.btn-blue").click
     sleep 2
  end
  
  Then 'I confirm that payment and reservation went well' do
    puts 'Not implemented yet'.yellow
  end
  
  And 'I click on "Create a New Ad" button' do
    page.find("a#btn_new").click
    sleep 5
  end
  
  Then 'I click on "Save" button to save new ad campaign' do
    page.find("#btn_save").click
    sleep 2
  end
  
  And 'I confirm that warning messages shows up' do
    sleep 2
    page.should have_content("Name can't be blank")
    page.should have_content("Template can't be blank")
    page.should have_content("Duration days must be at least one day.")
    page.should have_content("Location must be selected") 
  end
  
  Then 'I select "Cancel" link' do
    page.find("#btn_cancel").click
    sleep 1
  end
  
  And 'I provide "Promo Name"' do
    $promo_name_global = "sln_qa_test_promo_name"
    fill_in("promotion_name", :with => $promo_name_global)
  end
  
  Then 'I select "Ad Type"' do
    page.find('#template_select').find('option[2]').select_option
  end
  
  And 'I provide "Starts" day' do
    fill_in("picker_start_date", :with => Time.now.strftime("%d-%m-%Y"))
  end
  
  Then 'I select "Starts" time' do
    page.find('#promotion_start_hour').find('option[3]').select_option
  end
  
  Then 'I select "Duration"' do
    page.find('#promotion_duration_days').find('option[3]').select_option
  end
    
  And 'I provide "Restrictions"' do
    fill_in("promotion_restrictions", :with => "QA SLN Restrictions")
  end
  
  And 'I select location in "Locations" list' do
    page.find(:css, "#promotion_facility_ids option", :text => $facility_name).click
    sleep 1
  end
  
  And 'I provide price' do
    $promotion_value_price = "5"
    fill_in("promotion_value_price", :with => $promotion_value_price)
  end
  
  When 'I count how many existing ad campaigns on the page' do
    $my_ad_campaigns_count = page.all("#promotions .promo_row a").count
  end
  
  And 'I verify that ad was created successful' do
    page.all("#promotions .promo_row a").count.should == $my_ad_campaigns_count + 1
    page.should have_content($promo_name_global)
  end
  
  And 'I select ad' do
    page.find(:css, ".promo_row", :text => $promo_name_global).click
  end
  
  Then 'I click on "View Details" button' do
    page.find("#btn_view_selected").click
    sleep 2
  end
  
  And 'I confirm "Campaign Info" page loads' do
    page.should have_content("Campaign Info")
    page.should have_content($promo_name_global)
    page.find("#btn_edit").should be_visible
    page.find("#btn_cancel").should be_visible
    page.find(:css, ".btn-blue.left1em", :text => "Delete").should be_visible
  end
  
  Then 'I select "Done" button' do
    page.find("#btn_cancel").click
    sleep 1
  end
  
  Then 'I click on "Edit Details" button' do
    page.find("#btn_edit_selected").click
    sleep 2
  end
  
  And 'I change promo price and name' do
    $updated_promo_name_global = $promo_name_global + "_new"
    $updated_promotion_value_price = "7.00"
    
    fill_in("promotion_name", :with => $updated_promo_name_global)
    fill_in("promotion_value_price", :with => $updated_promotion_value_price)
  end
  
  And 'I confirm that ad has been updated' do
    page.find("#promotion_name").value.should == $updated_promo_name_global
    page.find("#promotion_value_price").value.should == $updated_promotion_value_price
  end
  
  Then 'I click on "Publish" button to publish ad changes' do
    page.find("#btn_save").click
    sleep 1
  end
  
  And 'I delete ad' do
    page.find(:css, ".btn-blue.left1em", :text => "Delete").click
    page.driver.browser.switch_to.alert.accept
    sleep 3
  end
  
  Then 'I confirm that ad has been deleted' do
    page.all("#promotions .promo_row a").count.should == $my_ad_campaigns_count - 1
  end

  Then 'I click on "Review Terms of ParkEdge Account" link' do
    page.find("#tos_account").click
    sleep 2
  end
  
  And 'I confirm that "Terms of Use" popup appears' do
    page.should have_content("Terms of Use")
    page.should have_content("Additional Terms of Use for ParkEdge Advertising Services")
    page.should have_content("Additional Terms of Use for ParkEdge Reservations Services")
    page.should have_content("Additional Terms of Use for ParkEdge RealTime Services")
  end
  
  Then 'I close "Terms of Use" popup' do
    page.find(".close_popup").click
    sleep 1
  end
  
  Then 'I click on "Review Terms of Facility Assignment" link' do
    page.find("#tos_facilities").click
    sleep 2
  end
  
  And 'I confirm that "Terms of Facility Assignment" popup appears' do
    page.should have_content("Terms of Facility Assignment")
  end
    
  Then 'I close "Terms of Facility Assignment" popup' do
    page.find(".close_popup").click
    sleep 1
  end
  
  Then 'I click on "Review Terms of ParkEdge Reservations" link' do
    page.find("#tos_reservations").click
    sleep 2
  end
    
  And 'I confirm that "Terms of ParkEdge Reservations" popup appears' do
    page.should have_content("Terms of ParkEdge Reservations")
  end
  
  Then 'I close "Terms of ParkEdge Reservations" popup' do
    page.find(".close_popup").click
    sleep 1
  end
  
  Then 'I click on "Reset Password" button' do
    page.find("#btn_password-reset").click
    sleep 1
  end
  
  And 'I verify that "Change Password" page loads as expected' do
    current_path.should == ("/password/change")
    page.should have_content("Change Password")
    page.find("#user_current_password").should be_visible
    page.find("#user_password").should be_visible
    page.find("#user_password_confirmation").should be_visible
    page.find("#btn_save").should be_visible
    page.find("#btn_cancel").should be_visible
  end
  
  And 'I click on "Edit" button on "Accounts" page' do
    page.find("#btn_user-contact").click
    sleep 1
  end
  
  Then 'I confirm that "Edit Account Information" loads' do
    current_path.should == ("/owners/edit")
    page.should have_content("Edit Account Information")
    page.find("#user_name").should be_visible
    page.find("#user_owned_account_attributes_name").should be_visible
    page.find("#user_contact_info_attributes_street_address").should be_visible
    page.find("#user_contact_info_attributes_locality").should be_visible
    page.find("#user_contact_info_attributes_region").should be_visible
    page.find("#user_contact_info_attributes_postal_code").should be_visible
    page.find("#user_current_password").should be_visible
    page.find("#btn_save").should be_visible
    page.find("#btn_cancel").should be_visible
  end
  
  And 'I click on "Upgrade to Premium" button' do
    page.find("#btn_billing-edit").click
    sleep 1
  end
  
  Then 'I cinfirm that "Upgrade to Premium Membership Free Tria" page loads' do
    current_path.should == ("/account_billing_infos/upgrade_to_premium_free_trial_confirm")
    page.should have_content("Upgrade to Premium Membership Free Trial")
    page.find("#btn_confirm").should be_visible
    page.find("#btn_cancel").should be_visible
  end
  
  
  Then 'I click on "Add" button to add a new user' do
    page.find("#btn_user-add").click
  end
  
  Then 'I confirm that "New User" page loads' do
    current_path.should == ("/account_users/new")
    page.should have_content("New User")
    page.find("#account_user_name").should be_visible
    page.find("#account_user_username").should be_visible
    page.find("#account_user_email").should be_visible
    page.find("#account_user_contact_info_attributes_phone").should be_visible
    page.find("#account_user_password").should be_visible
    page.find("#account_user_password_confirmation").should be_visible
    page.find("#btn_save").should be_visible
    page.find("#btn_cancel").should be_visible
  end
    
  And 'I click on "Save" button to create a new user' do
    page.find("#btn_save").click
    sleep 3
  end
    
  Then 'I confirm that "Username is required" and "Password is required" messages appeared' do
    page.should have_content("Password is required")
    page.should have_content("Username is required")
  end
  
  And 'I count sub-accounts' do
    sleep 1
    $original_count_of_sub_accounts = page.all("#user_select option").count
  end
  
  And 'I provide real name' do
    $account_user_name = "QA SUB ACCOUTN NAME"
    fill_in("account_user_name", :with => $account_user_name)
  end
  
  And 'I provide user name' do
    $account_user_username = "QA_SUB_ACCOUTN_USER_NAME_#{Time.now.to_i}"
    fill_in("account_user_username", :with => $account_user_username)
  end
    
  And 'I provide email' do
    $account_user_email = "sub_account@example.com"
    fill_in("account_user_email", :with => $account_user_email)
  end
  
  And 'I provide phone' do
    $phone_number = "(650) 242-3400"
    fill_in("account_user_contact_info_attributes_phone", :with => $phone_number)
  end
  
  And 'I provide password' do
    fill_in("account_user_password", :with => "secret123")
  end
    
  And 'I Re-enter pasword' do
    fill_in("account_user_password_confirmation", :with => "secret123")
  end
  
  Then 'I confirm that sub-account has been created' do
    page.should have_content($account_user_name)
    
    page.all("#user_select option").count.should == $original_count_of_sub_accounts + 1
  end
  
  And 'I select sub-user' do
    sleep 1
    page.find(:css, "#user_select option", :text => $account_user_name).click
  end
  
  And 'I select updated sub-user' do
    sleep 1
    page.find(:css, "#user_select option", :text => $updated_account_user_name).click
  end
  
  Then 'I click on "Edit" button to edit sub-user info' do
    page.find("#btn_user-edit").click
  end
  
  And 'I edit sub-user real name' do
    $updated_account_user_name = "QA SUB ACCOUTN NAME"
    fill_in("account_user_name", :with => $updated_account_user_name)
  end
  
  And 'I edit sub-user username' do
    $updated_account_user_username = "qa_sub_accoutn_user_name_#{Time.now.to_i}"
    fill_in("account_user_username", :with => $updated_account_user_username)
  end
  
  And 'I click on "Save" button to save my changes' do
    page.find("#btn_save").click
    sleep 1
  end
  
  Then 'I verify that I hanged sub-user information' do
    page.should have_content($updated_account_user_name)
    page.all("#user_select option").count.should == $original_count_of_sub_accounts
  end
  
  Then 'I click on "Delete" button to delete sub-user' do
    page.find("#btn_user-delete").click
  end
  
  Then 'I confirm that I to delete sub-user account' do
    page.should have_content("QA SUB ACCOUTN NAME")
    page.find("#btn_confirmdel").click
  end
  
  And 'I confirm that sub-user has been deleted' do
    page.should_not have_content("qa_sub_accoutn_user_name_")
    page.all("#user_select option").count.should == $original_count_of_sub_accounts - 1
  end
  
  Then 'I select "View" button' do
    page.find("#btn_user-info").click
  end
  
  And 'I verify that "User Info" page appears' do
    sleep 1
    page.should have_content("QA SUB ACCOUTN NAME ")
    page.should have_content("qa_sub_accoutn_user_name_")
    page.should have_content($phone_number)
    page.should have_content($account_user_email)
    page.find("#btn_edit").should be_visible
    page.find("#btn_done").should be_visible
  end
  
  And 'I click on "Reports" button' do
    page.find(".btn.right").click
  end
  
  Then 'I verify that "New Account Summary for Streetline" page loads as expected' do
    current_path.should == ("/admin/reports")
    page.should have_content("New Account Summary for Streetline")
    page.find(".section").should be_visible
    page.find(".btn.right").should be_visible
    page.find(".btn.left1em").should be_visible
    page.find("#month").should be_visible
    page.find("#start").should be_visible
    page.find("#end").should be_visible
    page.find(".data-table").should be_visible
  end

  And 'I click on "Facility Report" button' do
    page.click_on("Facility Report")
    sleep 1
  end
  
  Then 'I verify that "Facility Counts for Streetline" page loads as expected' do
    current_path.should == ("/admin/reports/facilities")
    page.should have_content("Facility Counts for Streetline")
    page.should have_content("Facility Totals")
    page.should have_content("Owned Facility Counts by Account Creation Date")
    page.should have_content("Owned Facility Counts by Facility Creation or Claim Date")
    page.find(".btn.right").should be_visible
    page.find(".btn.left1em").should be_visible
    page.find(".section").should be_visible
    page.should have_css(".section", :cont => 3)
    page.find(".reporting").should be_visible
    page.find("#start").should be_visible
    page.find("#end").should be_visible
  end
  
  And 'I click on "Admin" button to navigate to the "Administration" page' do
    page.find(".btn.left1em").click
  end
  
  And 'I fill in "Search for" text file with valid account name' do
    fill_in("search_value", :with => $user_name)
  end
  
  Then 'I click on "Contains" button' do
    page.click_on("Contains")
  end
    
  And 'I confirm that I have search result' do
    sleep 1
    page.all(".general tr").count.should >= 1
  end
  
  Then 'I click on "Exact Match" button' do
    page.click_on("Exact Match")
  end
  
  Then 'I fill in "Search for" text file with invalid account name' do
    fill_in("search_value", :with => "        ")
  end
  
  Then 'I confirm that I have empty search result' do
    page.should have_content("The record you requested was not found.")
  end
  
  And 'I click on "Manage accounts" button' do
    page.click_on("Manage accounts")
    sleep 1
  end
  
  Then 'I verify that "Accounts" page appears' do
    sleep 1
    current_path.should == ("/admin/accounts")
    page.should have_content("Accounts")
    page.should have_content("List of Accounts")
    page.find(:css, ".content.locations td a", :text => "Edit Account Info").should be_visible
    page.find(:css, ".content.locations td a", :text => "Edit Facilities").should be_visible
    page.find(:css, ".content.locations td a", :text => "Edit Owner").should be_visible
    page.find(:css, ".content.locations td a", :text => "Email activation link").should be_visible
    page.find(:css, ".content.locations td a", :text => "Destroy").should be_visible
    page.find("#search_string").should be_visible
  end
  
  And 'I click on "Edit Account Info" link' do
    page.find(:css, ".content.locations td a", :text => "Edit Account Info").click
    sleep 1
  end
  
  Then 'I confirm "Editing Account" page loads' do
    page.should have_content("Editing Account")
    page.find("#account_name").should be_visible
    page.find("#account_billing_info_attributes_subscription_plan_id").should be_visible
    page.find("#account_billing_info_attributes_subscription_free_trial_end_1i").should be_visible
    page.find("#account_billing_info_attributes_subscription_free_trial_end_2i").should be_visible
    page.find("#account_billing_info_attributes_subscription_free_trial_end_3i").should be_visible
    page.find("#account_is_pending").should be_visible
    page.find(".actions").should be_visible
    page.find(:css, ".content.locations a", :text => "Back").should be_visible
  end
    
  Then 'I click on back browser button' do
    #page.find(:css, ".content.locations a", :text => "Back").click
    page.evaluate_script('window.history.back()')
    sleep 1
  end
  
  And 'I click on "Edit Facilities" link' do
    page.find(:css, ".content.locations td a", :text => "Edit Facilities").click
    sleep 1
  end
  
  Then 'I confirm "Locations" page loads' do
    current_path.should == ("/garages")
  end
  
  And 'I click on "Edit Owner" link' do
    page.find(:css, ".content.locations td a", :text => "Edit Owner").click
    sleep 1
  end
  
  Then 'I confirm "Edit or Create Account Owner" page loads' do
    page.should have_content("Edit/Create Account Owner")
    page.find("#user_name").should be_visible
    page.find("#user_email").should be_visible
    page.find("#user_username").should be_visible
    page.find("#user_password").should be_visible
    page.find("#user_password_confirmation").should be_visible
    page.find(".actions").should be_visible
    page.find(:css, ".content.locations a", :text => "Back").should be_visible
  end
  
  And 'I click on "Email activation link" link' do
    page.find(:css, ".content.locations td a", :text => "Email activation link").click
    sleep 1
  end
    
  Then 'I confirm "Email Account Owner" page loads' do
    page.should have_content("Email Account Owner")
    page.find("#message").should be_visible
    page.find(".actions").should be_visible
    page.find(:css, ".content.locations a", :text => "Back").should be_visible
  end
  
  And 'I confirm that "Destroy" link presents on the page' do
    page.find(:css, ".content.locations td a", :text => "Destroy").should be_visible
  end
  
  And 'I enter account name in to the " Search by account name" search field' do
    $account_name = "Streetline Quality Assurance"
    fill_in("search_string", :with => $account_name)
  end
  
  Then 'I click on "Submit" button' do
    page.click_on("Submit")
    sleep 5
  end
  
  And 'I confirm that I have valid search result' do
    page.find(:css, ".locations tr td", :text => $account_name).should be_visible
  end
  
  And 'I click on "New Pending Account" link' do
    page.click_on("New Pending Account")
    sleep 1
  end
  
  Then 'I verify "New Account" page show up' do
    current_path.should == ("/admin/accounts/new")
    page.should have_content("New Account")
    page.find("#account_name").should be_visible
    page.find("#account_billing_info_attributes_subscription_plan_id").should be_visible
    page.find("#account_billing_info_attributes_subscription_free_trial_end_1i").should be_visible
    page.find("#account_billing_info_attributes_subscription_free_trial_end_2i").should be_visible
    page.find("#account_billing_info_attributes_subscription_free_trial_end_3i").should be_visible
    page.find(".actions").should be_visible
    page.find(:css, ".content.locations a", :text => "Back").should be_visible
  end
  
  Then 'I click on "Back" link' do
    page.find(:css, ".content.locations a", :text => "Back").click
    sleep 2
  end
  
  And 'I click on "Manage Rejected Facilities" link' do
    page.click_on("Manage Rejected Facilities")
    sleep 1
  end
    
  Then 'I verify that "Rejected Facilities" page loads' do
    current_path.should == ("/admin/accounts/rejected_facilities")
    page.should have_content("Rejected Facilities")
  end

  And 'I enter sub-user login name' do
    $sun_user_login_name = "sln_qa_sub_user "
    fill_in("username", :with => $sun_user_login_name)
  end
    
  And 'I enter sub-user password' do
    fill_in("password", :with => "please")
  end
  
  And 'I confirm that "Locations" page shows up as expected' do
    sleep 3
    current_path.should == ("/garages")
    page.find(".menu").should be_visible
    page.should have_css(".menu li", :count => 5)
    page.find("#map_div").should be_visible
    page.find("#address").should be_visible
    page.find("#btn_more").should be_visible
  end
  
  Then 'I confirm that sub-user sees "Make full use of ParkEdge with a Premium Subscription." message' do
    current_path.should == ("/subscription_info")
    page.should have_content("Make full use of ParkEdge with a Premium Subscription")
    page.should have_content("If your organization upgrades to a Premium ParkEdge Subscription, you can")
    page.should have_content("Set availability of your parking spots")
    page.should have_content("Advertise")
    page.should have_content("Set up event reservations")
  end
  
  And 'I click on "Operating Hours" tab' do
    page.find("#btn_hours").click
  end
  
  Then 'I check 7 days a week 24 hours checkboxes' do
    sleep 2
    page.find(:css, "#facility_hours_of_operation_attributes_mon_24_hour").set(true)
    #page.find(:css, "#facility_hours_of_operation_attributes_tues_24_hour").set(true)
    #page.find(:css, "#facility_hours_of_operation_attributes_wed_24_hour").set(true)
    #page.find(:css, "#facility_hours_of_operation_attributes_thu_24_hour").set(true)
    #page.find(:css, "#facility_hours_of_operation_attributes_fri_24_hour").set(true)
    #page.find(:css, "#facility_hours_of_operation_attributes_sat_24_hour").set(true)
    #page.find(:css, "#facility_hours_of_operation_attributes_sun_24_hour").set(true)
  end
  
  Then 'I save my changes for Operating Hours' do
    page.find("#btn_edit_submit").click
    sleep 2
  end
  
  Then 'I verify that 7 days a week 24 hours checkboxes are checked' do
    page.find('#facility_hours_of_operation_attributes_mon_24_hour').should be_checked 
    #monday_checkbox = page.find('#facility_hours_of_operation_attributes_mon_24_hour').should be_checked 
    #monday_checkbox.should be_checked  
  end
  
  And 'I uncheck 7 days a week 24 hours checkboxes' do
    sleep 2
    page.find(:css, "#facility_hours_of_operation_attributes_mon_24_hour").set(false)
    #page.find(:css, "#facility_hours_of_operation_attributes_tues_24_hour").set(false)
    #page.find(:css, "#facility_hours_of_operation_attributes_wed_24_hour").set(false)
    #page.find(:css, "#facility_hours_of_operation_attributes_thu_24_hour").set(false)
    #page.find(:css, "#facility_hours_of_operation_attributes_fri_24_hour").set(false)
    #page.find(:css, "#facility_hours_of_operation_attributes_sat_24_hour").set(false)
    #page.find(:css, "#facility_hours_of_operation_attributes_sun_24_hour").set(false)
  end
  
  And 'I verify that 7 days a week 24 hours checkboxes are unchecked' do
    page.find('#facility_hours_of_operation_attributes_mon_24_hour').should_not be_checked
  end
  
  Then 'I select qa test facility' do
    using_wait_time(10) do
      page.should have_content($facility_name)
    end
    page.click_on($facility_name)
    sleep 1
  end
  
  And 'I select "Payments and Policies" tab' do
    page.find("#btn_payment").click
    sleep 1
  end
  
  Then 'I check "Validation", "Visa", "Cash" and "Discover" checkboxes' do
    page.find(:css, "#payment_method_ids", :text => "Cash").set(true)
    #page.find(:css, "#payment_method_ids").set(true)
    #page.find(:css, "#payment_method_ids").set(true)
    #page.find(:css, "#payment_method_ids").set(true)
  end
  
  
  
end







