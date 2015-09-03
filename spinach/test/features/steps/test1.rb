class Test1 < Spinach::FeatureSteps
  
  Then 'I cleanup' do
    page.cleanup!
  end
    
  Given 'I navigate to Survey Tool page' do
    #visit "http://streetline:566tickets@survey-dev.streetline.com/"
    #visit "http://aleks:Abcd1234@survey-dev-plat.streetline.com/"
    #visit "http://Aleks:Abcd1234@survey-staging.streetline.com/" #STAGING
    #visit "http://Aleks:Abcd1234@survey.streetline.com/" # PROD
    #page.driver.browser.manage.window.maximize
    
    visit "http://survey-dev-plat.streetline.com/session/new"
    
    fill_in("login", :with => 'Aleks')
    fill_in("password", :with => 'Abcd1234')
    page.find(".btn").click
    page.driver.browser.manage.window.maximize
    
  end
  
  Then 'I navigate to the test city' do
    sleep 1
    page.select("Streetline", :from => "city_cd")
    #page.select("Zug", :from => "city_cd")
    sleep 1
    #page.select("Reno", :from => "city_cd")
    #sleep 1
    #puts current_url
    
  end
  
  And 'I find out current version' do
    $home_page = current_url
    sleep 1
    visit $home_page + "version.txt"
    sleep 1
    version_txt = page.find("pre").text
    puts "Test is performing against " + "#{version_txt}".yellow + " version."
    visit $home_page
    sleep 2
  end 
  
  Then 'I navigate to "Survey | Block Creation | Mass Assignment Tool" page' do
    #page.click_on("Survey | Block Creation | Mass Assignment Tool")
    page.click_on("Survey")
    sleep 1
  end
  
  
  And 'I select network on left navigation' do
    #page.find(:css, "#list_view_list li:last input").click
    page.find("#list_view_list li input:last").click

    sleep 2
  end
    
  When 'I memorize how many devices in this network' do
    #puts page.all('#list_view_list .block_title').count
    #puts page.all('#list_view_list li span').count
    
    sleep 2
    #$device_count_before_creation = page.all('#list_view_list li span').count
    $device_count_before_creation = page.all('#list_view_list li').count
    puts "Oroginal cont ===> #{$device_count_before_creation}".blue
  end
    
  Then 'I click on "V" button on top menu bar' do
    page.find("#V_button").click
    sleep 1 
  end
  
  And 'I place device' do
    #page.find('#map_canvas div:nth-child(2)').click
    page.find('#map_canvas div:nth-child(2)').click
    sleep 3
  end
  
  Then 'I provide street' do
    sleep 1
    page.should have_content("Lat")
    page.should have_content("Long")
    
    $original_name = fill_in("location_street_name", :with => "QA Street A")
  end
  
  Then 'I enter number' do
    $original_number = fill_in("location_street_number", :with => Time.now.to_i)
  end
  
  And 'I check "Force unique street name" checkbox' do
    page.find("#sure").set(true)
  end
  
  And 'I click on "Save" button' do
    sleep 1
    page.click_on("Save")
    sleep 3
  end
  
  Then 'I verify that new device has been created' do

    device_count_after_creation = page.all('#list_view_list li').count  
    ($device_count_before_creation +1).should == device_count_after_creation
    
    puts "Plus one count ===> #{device_count_after_creation}".blue
  end

  Then 'I click on device on the map' do
    sleep 1
    #puts page.all("div.gmnoprint:first img").count
    page.find('#map_canvas div.gmnoprint:last').click
    sleep 5
  end

  Then 'I verify that "Editing Vehicle Sensor" window appears' do
    page.should have_content("Editing Vehicle Sensor")
  end

  And 'I edit vehicle sensor information' do
    sleep 3
    edited_street_name = fill_in("location_street_name", :with => "QA Street Z")
    edited_street_number = fill_in("location_street_number", :with => Time.now.to_i)
    sleep 1
    $edited_street_name = page.find("#location_street_name").value
    $edited_street_number = page.find("#location_street_number").value
  end


  Then 'I verify that information has been edited' do
    #page.should have_content("Editing Vehicle Sensor")
    page.should have_content($edited_street_name)
    page.should have_content($edited_street_number)
    
    #page.should_not have_content($original_name)
    #page.should_not have_content($original_number)
  end

  Then 'I click on "Delete location" link' do
    page.click_on("Delete location")
    
    sleep 1
    #page.driver.browser.switch_to.alert.accept
    #sleep 1
  end

  And 'I click on "OK" on popup window' do
    page.driver.browser.switch_to.alert.accept
  end

  Then 'I verify that new device has been removed' do
    sleep 3
    device_count = page.all('#list_view_list li').count
    puts "Minus one count ===> #{device_count}".blue
    ($device_count_before_creation -1).should == device_count
  end

  And 'I memorize lat and long' do
    sleep 2
    $original_lat = page.find("#info_window_latitude").text
    $original_long = page.find("#info_window_longitude").text
    puts "Original Lat  #{$original_lat}".blue
    puts "Original Long #{$original_long}".blue
  end

  Then 'I drag device to a new location' do
    sleep 2
    original_location = page.find('#map_canvas div.gmnoprint img')
    #original_location = page.find('#map_canvas div:nth-child(2)')
    new_location = page.find('#map_canvas div:nth-child(3)')
    
    original_location.drag_to(new_location)
    sleep 3
  end

  When 'I drag and drop device to a new location' do
    sleep 2
    original_location = page.find('#map_canvas div.gmnoprint img')
    #new_location = page.find('#map_canvas div:nth-child(8)')
    new_location = page.find('#map_canvas div:nth-child(3)')
    
    original_location.drag_to(new_location)
    sleep 3
  end

  And 'I verify "Revert to saved position" link present' do
    sleep 3
    page.should have_content("Revert to saved position")
  end

  When 'I verify that device has a new lat and long' do
    sleep 3
    #$edited_street_name.should == page.find("#location_street_name").value
    #$edited_street_number.should == page.find("#location_street_number").value
    
    $new_lat = page.find("#info_window_latitude").text
    $new_long = page.find("#info_window_longitude").text
    
    $new_lat.should_not == $original_lat
    $new_long.should_not == $original_long
    
    puts "New lat  #{$new_lat}".blue
    puts "New long #{$new_long}".blue
  end

  And 'I verify that new position has been saved' do
    sleep 3
    $edited_street_name.should == page.find("#location_street_name").value
    $edited_street_number.should == page.find("#location_street_number").value
    
    check_lat = page.find("#info_window_latitude").text
    check_long = page.find("#info_window_longitude").text
    
    #puts check_lat
    #puts check_long
    
    $new_lat.should == check_lat
    $new_long.should == check_long
    #$new_lat.should  include(check_lat)
    #$new_long.should  include(check_long)
  end

  Then 'I click on "Revert to saved position" link' do
    page.click_on("Revert to saved position")
  end

  And 'I verify that device has been revirted to previous lat long position' do
    #$edited_street_name.should == page.find("#location_street_name").value
    #$edited_street_number.should == page.find("#location_street_number").value
    
    check_lat = page.find("#info_window_latitude").text
    check_long = page.find("#info_window_longitude").text
    
    $original_lat.should == check_lat
    $original_long.should == check_long
  end
  
  Then 'I click on "M" button' do
    page.find("#M_button").click
  end
  
  And 'I verify that " Editing Meter Monitor" window appears' do
    page.should have_content("Editing Meter Monitor")
  end
  
  Then 'I edit meter monitor information' do
    edited_street_name = fill_in("location_street_name", :with => "QA Street Z")
    edited_street_number = fill_in("location_street_number", :with => Time.now.to_i)
    sleep 1
    $edited_street_name = page.find("#location_street_name").value
    $edited_street_number = page.find("#location_street_number").value
  end
  
  Then 'I click on "R" button for repeater' do
    page.find("#R_button").click
  end
  
  And 'I verify "Editing Repeater" window appears' do
    page.should have_content("Editing Repeater")
  end
  
  Then 'I edit Repeater information' do
    edited_street_name = fill_in("location_street_name", :with => "QA Street Z")
    edited_street_number = fill_in("location_street_number", :with => Time.now.to_i)
    #sleep 1
    $edited_repeater_street_name = page.find("#location_street_name").value
    $edited_repeater_street_number = page.find("#location_street_number").value
    
    #puts $edited_repeater_street_name
    #puts $edited_repeater_street_number
  end
  
  And 'I verify that information has been saved' do
    street_name_val = page.find("#location_street_name").value
    street_number_val = page.find("#location_street_number").value
    
    page.should have_content("Editing Repeater")
    
    street_name_val.should == $edited_repeater_street_name
    street_number_val.should == $edited_repeater_street_number
  end
  
  Then 'I edit Gateway information' do
    edited_street_name = fill_in("location_street_name", :with => "QA Street Z")
    edited_street_number = fill_in("location_street_number", :with => Time.now.to_i)
    #sleep 1
    $edited_gateway_street_name = page.find("#location_street_name").value
    $edited_gateway_street_number = page.find("#location_street_number").value
  end
  
  And 'I verify Gateway information has been saved' do
    street_name_val = page.find("#location_street_name").value
    street_number_val = page.find("#location_street_number").value
    
    page.should have_content("Editing Gateway")
    
    street_name_val.should == $edited_gateway_street_name
    street_number_val.should == $edited_gateway_street_number
  end
  
  Then 'I verify new position of repeater' do
    sleep 3
    $edited_repeater_street_name.should == page.find("#location_street_name").value
    $edited_repeater_street_number.should == page.find("#location_street_number").value
    
    check_lat = page.find("#info_window_latitude").text
    check_long = page.find("#info_window_longitude").text
    
    $new_lat.should == check_lat
    $new_long.should == check_long
  end
  
  Then 'I click on "G" button' do
    page.find("#G_button").click
  end
  
  And 'I verify "Editing Gateway" window shows up' do
    page.should have_content("Editing Gateway")
  end
  
  And 'I verify Gateway\'s new position' do
    sleep 3
    $edited_gateway_street_name.should == page.find("#location_street_name").value
    $edited_gateway_street_number.should == page.find("#location_street_number").value
    
    check_lat = page.find("#info_window_latitude").text
    check_long = page.find("#info_window_longitude").text
    
    $new_lat.should == check_lat
    $new_long.should == check_long
  end
  
  And 'click on "T" button' do
    page.find("#T_button").click
  end
  
  When 'I verify "Editing Ground Truth Vehicle Sensor" window appears' do
    sleep 1
    page.should have_content("Editing Ground Truth Vehicle Sensor")
  end
  
  Then 'I edit GTVS information' do
    edited_street_name = fill_in("location_street_name", :with => "QA Street Z")
    edited_street_number = fill_in("location_street_number", :with => Time.now.to_i)
    #sleep 1
    $edited_GTVS_street_name = page.find("#location_street_name").value
    $edited_GTVS_street_number = page.find("#location_street_number").value
  end
  
  And 'I verify GTVS information has been saved' do
    street_name_val = page.find("#location_street_name").value
    street_number_val = page.find("#location_street_number").value
    
    page.should have_content("Editing Ground Truth Vehicle Sensor")
    
    street_name_val.should == $edited_GTVS_street_name
    street_number_val.should == $edited_GTVS_street_number
  end
  
  And 'I verify GTVS new position' do
    sleep 3
    $edited_GTVS_street_name.should == page.find("#location_street_name").value
    $edited_GTVS_street_number.should == page.find("#location_street_number").value
    
    check_lat = page.find("#info_window_latitude").text
    check_long = page.find("#info_window_longitude").text
    
    $new_lat.should == check_lat
    $new_long.should == check_long
  end
  
  Then 'I click on "U" button on menu' do
    page.find("#U_button").click
  end
  
  Then '"Editing Undemarcated Vehicle Sensor" window appears' do
    page.should have_content("Editing Undemarcated Vehicle Sensor")
  end
  
  And 'I verify UVS information has been saved as expected' do
    street_name_val = page.find("#location_street_name").value
    street_number_val = page.find("#location_street_number").value
    
    page.should have_content("Editing Undemarcated Vehicle Sensor")
    
    street_name_val.should == $edited_UVS_street_name
    street_number_val.should == $edited_UVS_street_number
  end
  
  And 'I edit UVS information' do
    edited_street_name = fill_in("location_street_name", :with => "QA Street Z")
    edited_street_number = fill_in("location_street_number", :with => Time.now.to_i)
    #sleep 1
    $edited_UVS_street_name = page.find("#location_street_name").value
    $edited_UVS_street_number = page.find("#location_street_number").value
  end
  
  And 'I click on "P" button on left filetr menu' do
    page.find("#filter_pole").click
  end
    
  Then 'I click on "P" button on top menu' do
    page.find("#P_button").click
  end
  
  And '"Editing Pole" window appears' do
    page.should have_content("Editing Pole")
  end
  
  And 'I edit Pole information' do
    edited_street_name = fill_in("location_street_name", :with => "QA Street Z")
    edited_street_number = fill_in("location_street_number", :with => Time.now.to_i)
    #sleep 1
    $edited_pole_street_name = page.find("#location_street_name").value
    $edited_pole_street_number = page.find("#location_street_number").value
  end
  
  Then 'I verify Pole information has been changed and saved' do
    street_name_val = page.find("#location_street_name").value
    street_number_val = page.find("#location_street_number").value
    
    page.should have_content("Editing Pole")
    
    street_name_val.should == $edited_pole_street_name
    street_number_val.should == $edited_pole_street_number
  end
  
  
  When 'I click on "VM" button on top menu' do
    page.find("#VM_button").click
  end
  
  And 'I place VS device' do
    sleep 1
    page.find('#map_canvas div:nth-child(2)').click
  end
  
  And 'I place MM device on the map' do
    sleep 1
    page.find('#map_canvas div:nth-child(4)').click
  end
  
  Then 'I select network in drop-down menu' do
    sleep 1
    option = page.find('#network_id').find('option[2]').select_option
    sleep 1
  end
  
  And 'I provide street name' do
    fill_in("street_name", :with => "QA Street A")
  end
    
  And 'I enter street number' do
    fill_in("street_number", :with => Time.now.to_i)
  end
  
  
  
  
  And 'I verify that new devices were created' do
    device_count_after_creation = page.all('#list_view_list li').count  
    ($device_count_before_creation +2).should == device_count_after_creation
    
    puts "Plus two count ===> #{device_count_after_creation}".blue
  end
  
  Then 'I click "Save" button' do
    sleep 1
    page.click_on("Save")
    sleep 5
  end
  
  And 'I select device' do
    page.find("#map_canvas div.gmnoprint:last").click
    sleep 3
  end
  
  When 'I verify that devices have been removed' do
    sleep 2
    device_count = page.all('#list_view_list li').count
    puts "Minus one count ===> #{device_count}".blue
    ($device_count_before_creation -2).should == device_count
  end
  
  Then 'timer started' do
    $timer_started = Time.now
    #puts $timer_started
  end
  
  Then 'timer stoped' do
    puts "Run Time: #{((Time.now - $timer_started) / 60).round(2)} min(s)".blue
  end
  
  And 'I make sure that QA test network does not exist' do
    network_name_txt = page.find(".block_title:first").text
    network_name_check = page.find(".block_title:first").text == "11111_QA"
    #puts "Network name ==> " + "#{network_name_txt}".yellow
    
    if network_name_check == true
      visit $home_page + "sln/networks"
      network_name_txt.should == page.find("#container td:first").text
      page.all("#container a")[1].click
      page.should have_content(network_name_txt)
      
      page.click_on("Destroy")
      page.driver.browser.switch_to.alert.accept
      #page.driver.browser.switch_to.alert.dismiss

      puts "Following network has been deleted ==> " + "#{network_name_txt}".yellow
    else
      #puts "QA test network does not exist on the page".blue
    end
  end
  
  Then 'I create a new network' do
    page.find(".new_network a").click
    using_wait_time(5) do
      page.find("#network_name").should be_visible
    end
    #page.click_on("New network")
    fill_in("network_name", :with => "11111_QA")
    page.click_on("Create")
    sleep 2
  end
  
  And 'I verify that network has been created' do
    (page.find(".block_title:first").text).should == "11111_QA"
  end
  
  And 'I verify that QA test network exists' do
    (page.find(".block_title:first").text).should == "11111_QA"
  end
  
  Then 'I navigate to "Edit" page and destroy network' do
    network_name_txt = page.find(".block_title:first").text
    network_name_check = page.find(".block_title:first").text == "11111_QA"
    #puts "Network name ==> " + "#{network_name_txt}".yellow
    
    if network_name_check == true
      visit $home_page + "sln/networks"
      network_name_txt.should == page.find("#container td:first").text
      page.all("#container a")[1].click
      page.should have_content(network_name_txt)
      
      page.click_on("Destroy")
      page.driver.browser.switch_to.alert.accept
      #page.driver.browser.switch_to.alert.dismiss

      puts "Following network has been deleted ==> " + "#{network_name_txt}".yellow
    else
      puts "Oops!!! Something went wrong".red
    end
  end
  
  
  
end

