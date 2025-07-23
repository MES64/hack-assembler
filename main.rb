# frozen_string_literal: true

# File Path: ~/Documents/Nand2Tetris/06/file.asm

require_relative 'lib/code'

code = Code.new

p code.dest('D')
p code.comp('A')
p code.comp('D+A')
p code.jump('JMP')

p code.comp('ksnxks')
p code.dest('skialk')
p code.jump('lkxsnm')

p code.dest(nil)
p code.jump(nil)
p code.comp(nil)
