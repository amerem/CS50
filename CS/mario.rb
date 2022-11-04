# frozen_string_literal:true

puts 'Please enter hight: '
i = gets.chomp.to_i
max = 23
while i < 1 || i > max
  puts "Hight should be between 1 and #{max}: "
  i = gets.chomp.to_i
end
puts "Thank you! You entered #{i}."

spaces = max - i
hashes = max

spaces.upto(hashes) { |x| puts ' ' * (max - x) + '#' * x }
