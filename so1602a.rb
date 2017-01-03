#
# so1602a.rb - a class for SO1602AWWB, SO1602AWGB, SO1602AWYB
#
# OLED Character Display Module 16x2
#   http://akizukidenshi.com/catalog/g/gP-08277/ (White)
#   http://akizukidenshi.com/catalog/g/gP-08276/ (Green)
#   http://akizukidenshi.com/catalog/g/gP-08278/ (Yellow)
#
# How to use
#     $ sudo gem install i2c
#     $ cat so1602a-test.rb
#
#       require_relative 'so1602a'
#       
#       so1602a = SO1602A.new
#       so1602a.print("hello SO1602A!!##123456789abcdef")
#
#     $ ruby so1602a-test.rb
#
# OLED Character Display Module Pin Assign
#     1 GND
#     2 Vdd (3.3V)
#     3 C/S (short to GND)
#     4 I2C Slave Address (L->0x3c, H->0x3d)
#     5 NC
#     6 NC
#     7 SCL (I2C clock)
#     8 SDA IN (I2C data)
#     9 SDA OUT (I2Cdata)
#     10～14 NC
#
#     ※ short (1,3,4) and (8,9)...![](img02.png)
#
# License:
#     Copyright (c) 2017 yoggy <yoggy0@gmail.com>
#     Released under the MIT license
#     http://opensource.org/licenses/mit-license.php;//
#
require 'i2c'
require 'pp'

class SO1602A
  I2C_SLAVE = 0x0703

  def initialize()
    @addr = 0x3c

    @i2c = I2C.create("/dev/i2c-1") # raspberry pi rev.2

    on()
    clear()
    contrast(0x7F)
  end

  def clear()
    write_cmd(0x01)
    move_home()
  end

  def on()
    write_cmd(0x0c) # 0x08+(display on/off->0x40)+(cursor on/off->0x02)+(blink on/off->0x01)
  end

  def contrast(val)
    write_cmd(0x2a)
    write_cmd(0x79)
    write_cmd(val)
    write_cmd(0x78)
    write_cmd(0x28)
  end

  def move_home()
    write_cmd(0x02)
  end

  def move_cursor(x, y)
    if y == 0
      write_cmd(0x80 + x)
    else
      write_cmd(0x80 + 0x20 + x)
    end
  end

  def print(str)
    if str == nil
      clear
      return
    end

    len = str.size
    len = 32 if len > 32 

    32.times do |i|
      if (i >= len) 
        write_char(0x20)
      else
        write_char(str[i].ord)
      end
      
      move_cursor(0, 1) if i == 15
    end

  end

  def print(str, y)
    move_cursor(0, y)

    len = 0
    unless str.nil?
      len = str.size
      len = 16 if len > 16
    end

    16.times do |i|
      if (i >= len) 
        write_char(0x20)
      else
        write_char(str[i].ord)
      end
    end
  end

  def write_char(c)
    write_data(0x40, c)
  end

  def write_cmd(cmd)
    write_data(0x00, cmd)
  end

  def write_data(c, d)
    data = [c, d].pack("C*")
    @i2c.write(@addr, data)
  end
end
