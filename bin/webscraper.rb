# frozen_string_literal: true

require_relative "../lib/webscraper"
require_relative "../lib/webscraper/robot"

robot = WebScraper::Robot.new(ARGV)

begin
  robot.run
# The Log will not be writable if the interrupt is caught by a Signal trap.
rescue Interrupt => Interrupt
  robot.log.fatal("interrupt detected")

  robot.stop
end
