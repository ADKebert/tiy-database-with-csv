class Person
  attr_accessor :name, :phone_number, :address, :position, :salary, :slack_account, :github_account

  def initialize(name, phone_num, address, position, salary, slack, github)
    self.name = name
    self.phone_number = phone_num
    self.address = address
    self.position = position
    self.salary = salary
    self.slack_account = slack
    self.github_account = github
  end
end
