# frozen_string_literal: true

# File Path: ~/Documents/Nand2Tetris/06/file.asm

require_relative 'lib/parser'

parser = Parser.new(ARGV[0])

p parser.instruction

# 1
p parser.more_lines?
p parser.advance
p parser.instruction
p parser.instruction_type
p parser.symbol

p parser.more_lines?
p parser.advance
p parser.instruction
p parser.instruction_type
p parser.dest
p parser.comp
p parser.jump

# 2
p parser.more_lines?
p parser.advance
p parser.instruction
p parser.instruction_type
p parser.symbol

p parser.more_lines?
p parser.advance
p parser.instruction
p parser.instruction_type
p parser.dest
p parser.comp
p parser.jump

# 3
p parser.more_lines?
p parser.advance
p parser.instruction
p parser.instruction_type
p parser.symbol

p parser.more_lines?
p parser.advance
p parser.instruction
p parser.instruction_type
p parser.dest
p parser.comp
p parser.jump

# 4
p parser.more_lines?
p parser.advance
p parser.instruction
p parser.instruction_type
p parser.symbol

p parser.more_lines?
p parser.advance
p parser.instruction
p parser.instruction_type
p parser.dest
p parser.comp
p parser.jump

p parser.more_lines?
p parser.advance
p parser.instruction
p parser.more_lines?
