require_relative 'person'

class Menu
  def initialize
    @people = []
  end

  def prompt_for_desired_action
    puts "What would you like to do with the database? Please enter the corresponding letter"
    puts "Add a person to the database (A)"
    puts "Search for a person (S)"
    puts "Delete a person from the database (D)"
    puts "Type (E) when you are finished"
    gets.chomp.downcase
  end

  def add_details_to_person(person)
    politeness = "Please enter #{person.name}'s"
    puts "#{politeness} phone number"
    person.phone_number = gets.chomp
    puts "#{politeness} address"
    person.address = gets.chomp
    puts "#{politeness} position"
    person.position = gets.chomp
    puts "#{politeness} salary"
    person.salary = gets.chomp
    puts "#{politeness} slack account"
    person.slack_account = gets.chomp
    puts "#{politeness} github account"
    person.github_account = gets.chomp
  end

  def add_new_person
    puts "What is the person's name?"
    @people << Person.new(gets.chomp)
    add_details_to_person(@people[-1])
  end

  def search_for_a_person(search_string)
    @people.select do |person|
      person.name =~ /#{search_string}/ ||
      person.slack_account == search_string ||
      person.github_account == search_string
    end
  end

  def describe_a_person(person)
    puts "Name: #{person.name}"
    puts "Phone Number: #{person.phone_number}"
    puts "Address: #{person.address}"
    puts "Position: #{person.position}"
    puts "Salary: #{person.salary}"
    puts "Slack Account: #{person.slack_account}"
    puts "Github Account: #{person.github_account}"
  end

  def search_prompt
    puts "Please enter part of the person's name, or their full slack or github account name"
    name = gets.chomp
    targets = search_for_a_person(name)
    if targets.empty?
      puts "That person was not found"
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
    else
      targets.each do |target|
        describe_a_person(target)
        puts "remove this person? (y/n)"
        response = gets.chomp
        if response == 'y'
          @people.delete(target)
          puts "#{target.name} was removed from the database"
        end
      end
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
      else
        done = true
      end
    end
  end
end
