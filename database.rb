require_relative 'person'
require_relative 'menu'
require 'csv'

class Database

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
end

db = Database.new
