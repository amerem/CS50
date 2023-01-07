require 'colorize'

puts "Number One:"
x = gets.chomp.to_f

puts "Number Two:"
y = gets.chomp.to_f
def calc(x, y)
  puts "Sum of #{x.to_s.yellow} and #{y.to_s.yellow} is #{x.to_s.cyan * y.to_s.cyan}"
end
calc(x, y)