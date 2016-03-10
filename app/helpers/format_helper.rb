module FormatHelper

  GIGA_SIZE = 1000000000.0
  MEGA_SIZE = 1000000.0
  KILO_SIZE = 1000.0

  def human_readable_bytes(size)
    size = Integer(size)
    case
      when size == 0 || size == 1
        '%d byte' % size
      when size < KILO_SIZE
        '%.d bytes' % size
      when size < MEGA_SIZE
        '%.1f kB' % (size / KILO_SIZE)
      when size < GIGA_SIZE
        '%.1f MB' % (size / MEGA_SIZE)
    end
  end
end
