# config/initializers/time_formats.rb
Time::DATE_FORMATS.merge!(
  :date_time => '%H:%M:%S %d/%m/%y',
  :time => '%H:%M:%S',
  :siso_date => '%d/%m/%y'
)
