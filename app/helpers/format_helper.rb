module FormatHelper
  GIGA_SIZE = 1_000_000_000.0
  MEGA_SIZE = 1_000_000.0
  KILO_SIZE = 1_000.0

  def human_readable_bytes(size)
    size = Integer(size)
    if size == 0 || size == 1
      format('%d byte', size)
    elsif size < KILO_SIZE
      format('%.d bytes', size)
    elsif size < MEGA_SIZE
      format('%.1f kB', (size / KILO_SIZE))
    elsif size < GIGA_SIZE
      format('%.1f MB', (size / MEGA_SIZE))
    end
  end
end
