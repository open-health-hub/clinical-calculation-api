require "rubygems"
require "bundler/setup"

require "./lib/ext/hash.rb"
require "./lib/ext/string.rb"
require "./lib/ext/symbol.rb"

require "./lib/helperloader.rb"

require "./lib/calculatorapp.rb"
require "./lib/calculatorloader.rb"
require "./lib/calculatorrouter.rb"

if __FILE__ == $0
  CalculatorApp.configure do |app|
    app.set :server_settings, { AccessLog: [] }
  end

  logger = Logging.logger_for "Server"

  helper = HelperLoader.new
  loader = CalculatorLoader.new helper
  router = CalculatorRouter.new loader

  helper.load_helpers "./helpers"
  loader.load_calculators "./calculators"

  begin
    CalculatorApp.setup(router).run!
  rescue => error
    logger.error "Error: #{error.message}"
    error.backtrace.each { |line| logger.error line }
  end
end
