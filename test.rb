a = [1,2,3]

a.each do |eff|
  puts 'hello'
end if a.respond_to? 'each'

puts 'done'
