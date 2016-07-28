class Person
  attr_accessor :name, :phone_number, :address, :position, :salary, :slack_account, :github_account

  def initialize(name)
    self.name = name
  end
end
