require_relative 'person'
require 'text-table'
require 'csv'

class Menu
  BUFFER = "\n" + "-" * 50 + "\n\n"
  def initialize
    @people = []
    read_from_csv
  end

  def prompt_for_desired_action
    puts "What would you like to do with the database? Please enter the corresponding letter"
    puts "Add a person to the database (A)"
    puts "Search for a person (S)"
    puts "Delete a person from the database (D)"
    puts "Create a report (R)"
    puts "Type (E) when you are finished"
    gets.chomp.downcase
  end

  def add_new_person
    puts "What is the person's name?"
    name = gets.chomp

    politeness = "Please enter #{name}'s"

    puts "#{politeness} phone number"
    phone_number = gets.chomp

    puts "#{politeness} address"
    address = gets.chomp

    puts "#{politeness} position"
    position = gets.chomp

    puts "#{politeness} salary"
    salary = gets.chomp

    puts "#{politeness} slack account"
    slack_account = gets.chomp

    puts "#{politeness} github account"
    github_account = gets.chomp

    @people << Person.new(name, phone_number, address, position, salary, slack_account, github_account)
    puts BUFFER
    puts "#{@people[-1].name} has been added to the database."
    puts BUFFER
    save_to_csv
  end

  def search_for_a_person(search_string)
    @people.select do |person|
      person.name =~ /#{search_string}/ ||
      person.slack_account == search_string ||
      person.github_account == search_string
    end
  end

  def describe_a_person(person)
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

  def search_prompt
    puts "Please enter part of the person's name, or their full slack or github account name"
    name = gets.chomp
    targets = search_for_a_person(name)
    if targets.empty?
      puts "That person was not found"
      puts BUFFER
    else
      targets.each do |target|
        describe_a_person(target)
      end
    end
  end

  def remove_a_person
    puts "What is the name of the person you would like to delete from the database?"
    targets = search_for_a_person(gets.chomp)
    if targets.empty?
      puts "That person was not found"
      puts BUFFER
    else
      targets.each do |target|
        describe_a_person(target)
        puts "remove this person? (y/n)"
        response = gets.chomp
        if response == 'y'
          @people.delete(target)
          puts "#{target.name} was removed from the database"
          puts BUFFER
          save_to_csv
        end
      end
    end
  end

  def read_from_csv
    CSV.foreach('employee.csv', headers: true, header_converters: :symbol) do |person|
      @people << Person.new(person[:name],
                            person[:phone],
                            person[:address],
                            person[:position],
                            person[:salary],
                            person[:slack],
                            person[:github])
    end
  end

  def save_to_csv
    CSV.open('employee.csv', 'w') do |csv|
      csv << %w{name phone address position salary slack github}
      @people.each do |person|
        csv << [person.name, person.phone_number, person.address, person.position,
                person.salary, person.slack_account, person.github_account]
      end
    end
  end

  def create_report
    find_positions.each do |position|
      employees = get_people_with_job(position)
      # puts BUFFER
      # puts "Position: #{position}  Salary Min: $#{get_min_salary(employees)}
      #       Max: $#{get_max_salary(employees)} Average: $#{get_avg_salary(employees)}"
      # puts "Number of #{position}s: #{employees.length}"
      # puts "Names: "
      # employees.each do |employee|
      #   print "#{employee.name} "
      # end
      # puts BUFFER
      p Text::Table.new
      report_table = Text::Table.new
      report_table.head = ["Salary Min", "Max", "Avg"]
      report_table.rows << [get_min_salary(employees),
                            get_max_salary(employees),
                            get_avg_salary(employees)]
      report_table.rows << :separator
      report_table.rows << [{ value: 'Number of employees:', colspan: 2 },
                            employees.size]
      names = ""
      employees.each do |employee|
        names += "#{employee.name} "
      end
      report_table.rows << :separator
      report_table.rows << ["Names:", { value: names, colspan: 2 }]
      puts report_table
    end
  end

  # Returns a list of unique postions in the database
  def find_positions
    positions = []
    @people.each do |person|
      unless positions.include? person.position
        positions << person.position
      end
    end
    positions
  end

  def get_min_salary(employees)
    min = Float::INFINITY
    employees.each do |employee|
      if employee.salary.to_f < min
        min = employee.salary.to_f
      end
    end
    min
  end

  def get_max_salary(employees)
    max = 0
    employees.each do |employee|
      if employee.salary.to_f > max
        max = employee.salary.to_f
      end
    end
    max
  end

  def get_avg_salary(employees)
    sum = 0
    employees.each do |employee|
      sum += employee.salary.to_f
    end
    sum / employees.length
  end

  def get_people_with_job(job)
    @people.select do |person|
      person.position == job
    end
  end

  def interact_with_the_db
    done = false
    until done
      case prompt_for_desired_action
      when 'a'
        add_new_person
      when 's'
        search_prompt
      when 'd'
        remove_a_person
      when 'r'
        create_report
      else
        done = true
      end
    end
  end
end
