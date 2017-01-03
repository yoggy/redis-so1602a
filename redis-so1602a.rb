#!/usr/bin/ruby
#
# redis-so1602a.rb - Display driver program for SO1602A and Rapsberry Pi
#
# How to setup
#   $ sudo apt-get install redis-server redis-tools ruby
#   $ sudo gem install redis
#   $ sudo gem install i2c
#
#   $ cd ~
#   $ mkdir work
#   $ cd work
#   $ git clone https://github.com/yoggy/redis-so1602a
#   $ cd redis-so1602a
#   $ ./redis-so1602a.rb
#
# How to use
#   $ redis-cli set "so1602a:0" "hello SO1602A!!"
#   $ redis-cli set "so1602a:1" "123456789abcdef"
#
# License:
#     Copyright (c) 2017 yoggy <yoggy0@gmail.com>
#     Released under the MIT license
#     http://opensource.org/licenses/mit-license.php;//
#
require 'redis'
require_relative 'so1602a'

redis = Redis.new
so1602a = SO1602A.new

# banner
so1602a.print("redis-so1602a.rb", 0)
so1602a.print("ver 0.0.1", 1)
sleep 3

# clear display
so1602a.clear

loop do 
  2.times do |i|
    str = redis.get("so1602a:#{i}")
    so1602a.print(str, i)
  end
  sleep 0.2
end
