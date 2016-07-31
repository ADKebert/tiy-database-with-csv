require_relative 'report'
require_relative 'display'

class Menu
  BUFFER = Display::BUFFER
  ADD = "Add a person to the database (A)"
  SEARCH = "Search for a person (S)"
  DELETE = "Delete a person from the database (D)"
  REPORT = "Create a report (R)"
  EXIT = "Type (E) when you are finished"
  TEXT_REPORT = "Would you like to print the report to terminal (T)"
  HTML_REPORT = "or save to html? (H)"
  SEARCH_PROMPT = "Please enter part of the name of the person or their full github or slack account"

  def initialize(database)
    @main_options = [ADD, SEARCH, DELETE, REPORT, EXIT]
    @report_options = [TEXT_REPORT, HTML_REPORT]
    @database = database
  end

  def response_to_main_prompt
    @main_options.each do |option|
      puts option
    end
    gets.chomp.downcase
  end

  def response_to_report_prompt
    @report_options.each do |option|
      puts option
    end
    gets.chomp.downcase
  end

  def response_to_search_prompt
    puts SEARCH_PROMPT
    gets.chomp
  end

  def use_database
    loop do
      case response_to_main_prompt
      when 'a'
        @database.add
      when 's'
        targets = @database.matching_employees(response_to_search_prompt)
        targets.each do |target|
          Display.person(target)
        end
      when 'd'
        @database.delete(@database.matching_employees(response_to_search_prompt))
      when 'r'
        report = Report.new(@database.people)
        if response_to_report_prompt == 't'
          report.text_report
        else
          report.html_report
        end
      else
        break
      end
    end
  end
end
