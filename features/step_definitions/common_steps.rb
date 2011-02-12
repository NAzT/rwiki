Then /^I enter the break point$/ do
  debugger
  p 'debugger'
end

Given /^this scenario is pending$/ do
  pending # always
end

When /^I open the application$/ do
  When %Q{I go to the home page}
  Then %{I should see disabled "Edit page" toolbar button}
  And %{I should see disabled "Print page" toolbar button}
end

When /^I reload the application$/ do
  Capybara.current_session.execute_script <<-JS
    window.location.reload();
  JS
end

When /^I open the application for page with path "([^"]*)"$/ do |path|
  visit('/#' + path)
end

Then /^I should see dialog box titled "([^"]*)"$/ do |title|
  %Q{Then I should see "#{title}" within "span.x-window-header-text"}
end

Then /^I should see page title "([^"]*)"$/ do |title|
  find("title").text.should == title
end

When /^I create a new page titled "([^"]*)" for the node with path "([^"]*)"$/ do |title, path|
  When %{I right click the node with path "#{path}"}
  And %{I follow "Create page"}
  Then %{I should see dialog box titled "Create page"}

  When %{I fill in the input with "#{title}" within the dialog box}
  And %{I press "OK" within the dialog box}
  Then %{I should see the node titled "#{title}"}
end

Then /^I should see generated content for the node with path "([^"]*)"$/ do |path|
  require 'lorax'

  wiki_page_html = Rwiki::Node.new(path).html_content
  wiki_page_html = "<div>#{wiki_page_html}</div>"
  page_html = Nokogiri::HTML(page.body).css('div.page-container:not(.x-hide-display)').first.inner_html
  page_html = "<div>#{page_html}</div>"

  result = Lorax.diff(wiki_page_html, page_html)
  result.deltas.should be_empty
end
