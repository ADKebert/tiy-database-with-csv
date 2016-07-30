class Menu
  BUFFER = "\n" + "-" * 50 + "\n\n"
  ADD = "Add a person to the database (A)"
  SEARCH = "Search for a person (S)"
  DELETE = "Delete a person from the database (D)"
  REPORT = "Create a report (R)"
  EXIT = "Type (E) when you are finished"
  TEXT_REPORT = "Would you like to print the report to terminal (T)"
  HTML_REPORT = "or save to html? (H)"
  SEARCH_PROMPT = "Please enter part of the name of the person or their full github or slack account"

  def initialize
    @main_options = [ADD, SEARCH, DELETE, REPORT, EXIT]
    @report_options = [TEXT_REPORT, HTML_REPORT]
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

  def display_person(person)
    puts BUFFER
    puts "Name: #{person.name}"
    puts "Phone Number: #{person.phone_number}"
    puts "Address: #{person.address}"
    puts "Position: #{person.position}"
    puts "Salary: #{person.salary}"
    puts "Slack Account: #{person.slack_account}"
    puts "Github Account: #{person.github_account}"
    puts BUFFER
  end

  def use_database
    # db = Database.new
    loop do
      case response_to_main_prompt
      when 'a'
        puts "call database.add"
      when 's'
        puts "call database.search(response_to_search_prompt)"
      when 'd'
        puts "call database.delete(response_to_search_prompt)"
      when 'r'
        if response_to_report_prompt == 't'
          puts "call report.text_report"
        else
          puts "call report.html_report"
        end
      else
        break
      end
    end
  end
end

Menu.new.use_database
