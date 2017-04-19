module Helper
  SECONDS_IN_MINUTE = 60
  SECONDS_IN_HOUR = 60 * 60
  SECONDS_IN_DAY = 60 * 60 * 24
  SECONDS_IN_YEAR = 60 * 60 * 24 * 365

  # Returns negative seconds for future dates
  def age(from_dt)
    to_dt = Time.current

    total_seconds = (to_dt - from_dt).to_i
    seconds = total_seconds
    if total_seconds > SECONDS_IN_YEAR
      years = seconds / SECONDS_IN_YEAR
      seconds -= (years * SECONDS_IN_YEAR)
    end
    if total_seconds > SECONDS_IN_DAY
      days = seconds / SECONDS_IN_DAY
      seconds -= (days * SECONDS_IN_DAY)
    end
    if total_seconds > SECONDS_IN_HOUR
      hours = seconds / SECONDS_IN_HOUR
      seconds -= (hours * SECONDS_IN_HOUR)
    end
    if total_seconds > SECONDS_IN_MINUTE
      minutes = seconds / SECONDS_IN_MINUTE
      seconds -= (minutes * SECONDS_IN_MINUTE)
    end
    return {years: years, days: days, hours: hours, minutes: minutes, seconds: seconds}
  end
end
