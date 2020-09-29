require 'json'
require 'date'

def read_file(file)
  File.write(file, '[]', mode: 'w') unless File.file?(file)
  data = File.read(file)
  data = JSON.parse(data)
  data.sort_by { |el| el['date'] }
end

def write_file(values, file, dolar_values)
  dolar_values << values
  dolar_file = File.write(file, JSON.generate(dolar_values), mode: 'w')
end

def get_user_inputs
  puts 'Digite a data: (dd/mm/aaaa)'
  date = gets.strip.split('/')
  raise 'Formato de data inválido' if date.length < 3

  puts 'Digite o valor:'
  dolar_price = gets.strip
  { 'date' => Date.new(*date.reverse.map(&:to_i)), 'price' => dolar_price }
end

def print_header(dolar_values)
  puts 'últimos valores'
  dolar_values.last(5).each do |dolar_value|
    puts "#{dolar_value['date'].split('-').reverse.join('/')} - #{dolar_value['price']}"
  end
end

def main
  file = 'dolar.json'
  dolar_values = read_file(file)
  print_header(dolar_values)
  values = get_user_inputs
  write_file(values, file, dolar_values)
rescue StandardError => e
  puts e.message == 'invalid date' ? 'Data inválida' : e.message
end

main
