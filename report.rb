require_relative 'htmlifier'
require 'text-table'

class Report
  REPORT_HEADER = "Salary Report"

  def initialize(employees)
    @report_data = {}
    create_report_data(employees)
  end

  def create_report_data(employees)
    positions_in_list(employees).each do |position|
      @report_data.store(position,
                         data_for_employees(employees_with_position(employees, position)))
    end
  end

  def data_for_employees(employees)
    data = {}
    data.store("min_salary", min_salary(employees))
    data.store("max_salary", max_salary(employees))
    data.store("avg_salary", avg_salary(employees))
    data.store("num_employees", employees.size)
    names = []
    employees.each do |employee|
      names << employee.name
    end
    data.store("names", names)
    data
  end

  def positions_in_list(employees)
    positions = []
    employees.each do |employee|
      unless positions.include? employee.position
        positions << employee.position
      end
    end
    positions
  end

  def min_salary(employees)
    min = Float::INFINITY
    employees.each do |employee|
      if employee.salary.to_f < min
        min = employee.salary.to_f
      end
    end
    min
  end

  def max_salary(employees)
    max = 0
    employees.each do |employee|
      if employee.salary.to_f > max
        max = employee.salary.to_f
      end
    end
    max
  end

  def avg_salary(employees)
    sum = 0
    employees.each do |employee|
      sum += employee.salary.to_f
    end
    sum / employees.length
  end

  def employees_with_position(employees, position)
    employees.select do |person|
      person.position == position
    end
  end

  def html_report
    File.open("report.html", "w") do |report_file|
      report = Htmlifier.new
      report.title = REPORT_HEADER
      report.add_line(report.h1(REPORT_HEADER))
      @report_data.each do |position, data|
        report.add_line(report.div_start("report-block"))
        report.add_line(report.h2("Position: #{position}"))
        report.add_line(report.ul_start)
        report.add_line(report.li(report.p("Salary Min: #{data["min_salary"].round(2)}")))
        report.add_line(report.li(report.p("Max: #{data["max_salary"].round(2)}")))
        report.add_line(report.li(report.p("Average: #{data["avg_salary"].round(2)}")))
        report.add_line(report.ul_end)
        report.add_line(report.p("Number of employees: #{data["num_employees"]}"))
        report.add_line(report.p("Names:"))
        report.add_line(report.ul_start)
        data["names"].each do |name|
          report.add_line(report.li(report.p(name)))
        end
        report.add_line(report.ul_end)
      end
      report_file.puts report
    end
  end

  def text_report
    @report_data.each do |position, data|
      report_table = Text::Table.new
      report_table.head = ["Salary Min", "Max", "Avg"]
      report_table.rows << [data["min_salary"].round(2),
                            data["max_salary"].round(2),
                            data["avg_salary"].round(2)]
      report_table.rows << :separator
      report_table.rows << [{ value: 'Number of employees:', colspan: 2 },
                            data["num_employees"]]
      report_table.rows << :separator
      report_table.rows << ["Names:", { value: data["names"], colspan: 2 }]
      puts report_table
    end
  end
end
