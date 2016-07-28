class Person
  attr_accessor :name, :phone_number, :address, :position, :salary, :slack_account, :github_account

  def initialize(name)
    self.name = name
  end

  def full_add(name, phone_num, address, position, slack, github)
    self.name = name
    self.phone_number = phone_num
    self.address = address
    self.position = position
    self.slack_account = slack
    self.github_account = github
  end
end
