# frozen_string_literal: true

require_relative 'parser'
require_relative 'code'

# Assembler contains Parser and Code objects
# It loops over each instruction and identifies its type using Parser
# It then breaks it up into symbols using Parser
# It then translates each symbol into binary code, with the help of Code
# Finally, it appends it all together and puts it into the output file
class Assembler
  attr_reader :parser, :code
  attr_accessor :counter

  def initialize
    @parser = Parser.new(ARGV[0])
    @code = Code.new
    @counter = 0
  end

  def asm_to_binary
    output_filename = "#{ARGV[0].split('.')[0]}.hack"
    output_file = File.open(output_filename, 'w')
    while parser.more_lines?
      parser.advance
      # In case there were initially more lines but they contained no instructions...
      break if parser.no_instruction?

      output_file.puts instruction_to_binary unless parser.instruction_type == :L_INSTRUCTION
      self.counter = counter + 1
    end
    parser.close_file
    output_file.close
  end

  private

  def instruction_to_binary
    return to_16bit unless parser.instruction_type == :C_INSTRUCTION

    to_c_instruction
  end

  def to_16bit
    # Note that all A-instructions/addresses must begin with a 0
    "0#{format('%015b', parser.symbol)[-15..]}"
  rescue StandardError
    raise "Error: Invalid instruction #{parser.instruction} at line #{counter}"
  end

  def to_c_instruction
    ddd = code.dest(parser.dest)
    jjj = code.jump(parser.jump)
    acccccc = code.comp(parser.comp)
    c_instruction = "111#{acccccc}#{ddd}#{jjj}"
    raise "Error: Invalid instruction #{parser.instruction} at line #{counter}" if c_instruction.length < 16

    c_instruction
  end
end
