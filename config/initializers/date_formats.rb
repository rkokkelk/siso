# config/initializers/time_formats.rb, :created_at
Time::DATE_FORMATS.merge!(
  date_time: '%H:%M:%S %d/%m/%y',
  date_time_ms: '%H:%M:%S.%6N %d/%m/%y',
  logging: ' %d/%m/%y %H:%M:%S.%6N',
  time: '%H:%M:%S',
  siso_date: '%d-%m-%Y'
)
