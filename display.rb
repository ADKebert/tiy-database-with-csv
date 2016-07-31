require_relative 'person'

class Display
  BUFFER = "\n" + "-" * 50 + "\n\n"
  #class method for displaying a person
  def self.person(person)
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
end
