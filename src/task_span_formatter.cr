class TaskSpanFormatter
  def format(span : Time::Span) : String
    if span.days > 30
      "#{span.days // 30} month"
    elsif span.days > 0
      "#{span.days}d"
    elsif span.hours > 0
      "#{span.hours}h"
    elsif span.minutes > 0
      "#{span.minutes}min"
    else
      "#{span.seconds}s"
    end
  end
end
