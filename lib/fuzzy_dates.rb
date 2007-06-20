class FuzzyDate
  include Comparable
  attr_reader :year, :month
  
  def initialize(year = nil, month = nil)
    @year, @month = year, month
  end
  
  def ==(other_date)
    (year == other_date.year) and (month == other_date.month)
  end
  
  def <=>(other_date)
    if year.nil?
      other_date.year.nil? ? 0 : -1
    elsif other_date.year.nil?
      1
    elsif year == other_date.year
      if month.nil?
        other_date.month.nil? ? 0 : -1
      elsif other_date.month.nil?
        1
      else
        month <=> other_date.month
      end
    else
      year <=> other_date.year
    end
  end
  
  def day
    nil
  end
  
  def to_s
    if year.nil?
      "(?)"
    elsif month.nil?
      "(#{year})"
    else
      "(#{Date::MONTHNAMES[month]})"
    end
  end
end
