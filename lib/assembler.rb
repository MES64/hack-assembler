# frozen_string_literal: true

require_relative 'parser'
require_relative 'code'

# Assembler contains Parser and Code objects
# It loops over each instruction and identifies its type using Parser
# It then breaks it up into symbols using Parser
# It then translates each symbol into binary code, with the help of Code
# Finally, it appends it all together and puts it into the output file
class Assembler
  attr_reader :code, :output_file, :symbol_table
  attr_accessor :parser, :counter, :register_number

  def initialize
    @parser = Parser.new(ARGV[0])
    @code = Code.new
    @counter = 0
    @output_file = File.open("#{ARGV[0].split('.')[0]}.hack", 'w')
    @symbol_table = { 'R0' => '0',
                      'R1' => '1',
                      'R2' => '2',
                      'R3' => '3',
                      'R4' => '4',
                      'R5' => '5',
                      'R6' => '6',
                      'R7' => '7',
                      'R8' => '8',
                      'R9' => '9',
                      'R10' => '10',
                      'R11' => '11',
                      'R12' => '12',
                      'R13' => '13',
                      'R14' => '14',
                      'R15' => '15',
                      'SP' => '0',
                      'LCL' => '1',
                      'ARG' => '2',
                      'THIS' => '3',
                      'THAT' => '4',
                      'SCREEN' => '16384',
                      'KBD' => '24576' }
    @register_number = 16
  end

  def assemble
    add_label_symbols
    asm_to_binary
  end

  def add_label_symbols
    self.parser = Parser.new(ARGV[0])
    self.counter = 0
    while parser.more_lines?
      parser.advance
      # In case there were initially more lines but they contained no instructions...
      break if parser.no_instruction?

      if parser.instruction_type == :L_INSTRUCTION
        symbol_table[parser.symbol] = counter
      else
        self.counter = counter + 1
      end
    end
    parser.close_file
  end

  def asm_to_binary
    self.parser = Parser.new(ARGV[0])
    self.counter = 0
    while parser.more_lines?
      parser.advance
      # In case there were initially more lines but they contained no instructions...
      break if parser.no_instruction?

      unless parser.instruction_type == :L_INSTRUCTION
        output_file.puts instruction_to_binary
        self.counter = counter + 1
      end
    end
    close_files
  end

  private

  def instruction_to_binary
    return to_16bit unless parser.instruction_type == :C_INSTRUCTION

    to_c_instruction
  end

  def to_16bit
    symbol = parser.symbol
    number = symbol.match?(/^\d+$/) ? symbol : symbol_table[symbol]
    if number.nil?
      symbol_table[symbol] = register_number
      number = register_number
      self.register_number += 1
    end
    # Note that all A-instructions/addresses must begin with a 0
    "0#{format('%015b', number)[-15..]}"
  rescue StandardError
    close_files
    raise "Error: Invalid instruction #{parser.instruction} at line #{counter}"
  end

  def to_c_instruction
    ddd = code.dest(parser.dest)
    jjj = code.jump(parser.jump)
    acccccc = code.comp(parser.comp)
    c_instruction = "111#{acccccc}#{ddd}#{jjj}"
    if c_instruction.length < 16
      close_files
      raise "Error: Invalid instruction #{parser.instruction} at line #{counter}"
    end

    c_instruction
  end

  def close_files
    parser.close_file
    output_file.close
  end
end
