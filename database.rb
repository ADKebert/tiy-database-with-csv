require_relative 'person'
require_relative 'menu'
require_relative 'display'
require 'csv'


class Database
  attr :people

  def initialize
    @people = []
    read_from_csv
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

  def add
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
    puts "#{Display::BUFFER}#{@people.last.name} has been added to the database.#{Display::BUFFER}"
    save_to_csv
  end

  def delete(potential_targets)
    if potential_targets.empty?
      puts "That person was not found"
      puts Display::BUFFER
    else
      potential_targets.each do |target|
        Display.person(target)
        puts "remove this person? (y/n)"
        response = gets.chomp
        if response == 'y'
          @people.delete(target)
          puts "#{target.name} was removed from the database"
          puts Display::BUFFER
          save_to_csv
        end
      end
    end
  end

  def matching_employees(search_string)
    @people.select do |person|
      person.name =~ /#{search_string}/ ||
      person.slack_account == search_string ||
      person.github_account == search_string
    end
  end

  def use
    menu = Menu.new(self)
    menu.use_database
  end
end

Database.new.use
