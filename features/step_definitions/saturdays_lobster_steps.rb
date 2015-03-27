When(/^I execute "(.*)"$/) do |command|
  output << SaturdaysLobster::CommandRunner.new(command).run
end

Then(/^the output should contain "(.*)"$/) do |expected_output|
  expect(output).to include expected_output
end
