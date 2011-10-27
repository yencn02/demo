When /^I submit the search form$/ do
  page.evaluate_script("document.forms[0].submit()")
#  page.evaluate_script("$(\"#search form\").submit()")
end