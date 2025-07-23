# frozen_string_literal: true

# Parser stores the .asm file to be read and the current instruction
# Parser has methods for checking if there are more lines, advancing to the next instruction,
# finding the instruction type, getting the symbol of an A/L-instruction, and getting the
# dest, comp, and jump part of a C-instruction
class Parser
  attr_reader :file
  attr_accessor :instruction

  def initialize(file_name)
    @file = File.open(file_name)
    @instruction = ''
  end

  def close_file
    file.close
  end

  def more_lines?
    !file.eof?
  end

  def no_instruction?
    instruction.empty? || instruction.start_with?('//')
  end

  def advance
    self.instruction = file.gets.strip
    self.instruction = file.gets.strip while no_instruction? && more_lines?
  end

  def instruction_type
    return :A_INSTRUCTION if instruction.start_with?('@')
    return :L_INSTRUCTION if instruction.start_with?('(') && instruction.end_with?(')')

    :C_INSTRUCTION
  end

  def symbol
    return instruction[1..] if instruction.start_with?('@')

    instruction[1...-1]
  end

  def dest
    return unless instruction.include?('=')

    instruction.split('=')[0]
  end

  def comp
    comp = instruction
    comp = comp.split('=')[1] if comp.include?('=')
    comp = comp.split(';')[0] if comp.include?(';')

    comp
  end

  def jump
    return unless instruction.include?(';')

    instruction.split(';')[1]
  end
end
