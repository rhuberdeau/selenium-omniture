require 'selenium-webdriver'
require 'rspec/expectations'
require 'capybara'
include RSpec::Matchers

def setup
  @session = Capybara::Session.new(:selenium)
end

def teardown
  Capybara.reset_sessions!
end

def run
  setup
  yield
  teardown
end

run do 
  @session.visit "http://www.adobe.com/marketing-cloud.html"

  #open debugger
  @session.execute_script "javascript:void(window.open(\"\",\"dp_debugger\",\"width=600,height=600,location=0,menubar=0,status=1,toolbar=0,resizable=1,scrollbars=1\").document.write(\"<script language='JavaScript' id=dbg src='https://www.adobetag.com/d1/digitalpulsedebugger/live/DPD.js'></\"+\"script>\"))"
  new_window = @session.windows.last

  #switch to debugger
  @session.within_window new_window do
    omniture_node = @session.find 'td#request_list_cell'
    omniture_text = omniture_node.text 
    if omniture_text == nil #quick check to make sure we have something
      sleep 1
      omniture_node = @session.find 'td#request_list_cell'
      omniture_node = @session.find 'td#request_list_cell'
      omniture_text = omniture_node.text 
    end

    puts omniture_text.length
  end
end