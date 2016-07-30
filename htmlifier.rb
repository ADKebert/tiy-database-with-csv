class Htmlifier
  INDENT = "  "
  HTML_TOP = "<!DOCTYPE html>\n<html>\n#{INDENT}<head>\n#{INDENT * 2}<meta charset=\"utf-8\">\n#{INDENT * 2}<link rel=\"stylesheet\" href=\"report.css\">\n"
  HTML_MID = "#{INDENT}</head>\n#{INDENT}<body>\n"
  HTML_BOT = "#{INDENT}</body>\n<html>"
  attr_accessor :title, :bodystring, :indent_level
  def initialize
    self.title = ""
    @body_lines = []
    self.bodystring = ""
    self.indent_level = 1
  end

  def title=(string)
    @title = "#{INDENT * 2}<title>" + string + "</title>\n"
  end

  def h1(string)
    @indent_level += 1
    string = "#{INDENT * @indent_level}<h1>" + string + "</h1>\n"
    @indent_level -= 1
    string
  end

  def h2(string)
    @indent_level += 1
    string = "#{INDENT * @indent_level}<h2>" + string + "</h2>\n"
    @indent_level -= 1
    string
  end

  def p(string)
    @indent_level += 1
    string = "#{INDENT * @indent_level}<p>" + string + "</p>\n"
    @indent_level -= 1
    string
  end

  def ul_start
    @indent_level += 1
    string = "#{INDENT * @indent_level}<ul>\n"
  end

  def li(string)
    save_indent = @indent_level
    @indent_level += 1
    str = "#{INDENT * @indent_level}<li>" + string.strip + "</li>\n"
    @indent_level -= 1
    str
  end

  def ul_end
    string = "#{INDENT * @indent_level}</ul>\n"
    @indent_level -= 1
    string
  end

  def div_start(string)
    @indent_level += 1
    string = "#{INDENT * @indent_level}<div class=\"#{string}\">\n"
  end

  def div_end
    string = "#{INDENT * @indent_level}</div>\n"
    @indent_level -= 1
    string
  end

  def add_line(string)
    @body_lines << string
  end

  def build_bodystring
    @body_lines.each do |line|
      @bodystring += line
    end
  end

  def to_s
    build_bodystring
    HTML_TOP + title + HTML_MID + bodystring + HTML_BOT
  end
end
