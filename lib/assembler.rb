# frozen_string_literal: true

require_relative 'parser'
require_relative 'code'

# Assembler contains Parser and Code objects
# It loops over each instruction and identifies its type using Parser
# It then breaks it up into symbols using Parser
# It then translates each symbol into binary code, with the help of Code
# Finally, it appends it all together and puts it into the output file
class Assembler
  attr_reader :parser, :code, :output_file
  attr_accessor :counter

  def initialize
    @parser = Parser.new(ARGV[0])
    @code = Code.new
    @counter = 0
    @output_file = File.open("#{ARGV[0].split('.')[0]}.hack", 'w')
  end

  def asm_to_binary
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
    # Note that all A-instructions/addresses must begin with a 0
    "0#{format('%015b', parser.symbol)[-15..]}"
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
