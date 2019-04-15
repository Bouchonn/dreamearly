require 'test/unit'
include Test::Unit::Assertions

class ParserTest
	## ruby -r './main.rb' -e 'ParserTest.run'
	def self.run
		assert_equal(Parser.prefix_to_infix(""), "", "wrong output")
		assert_equal(Parser.prefix_to_infix("3"), "3", "wrong output")
		assert_equal(Parser.prefix_to_infix("3 +"), "(+ 3 )", "wrong output")
		assert_equal(Parser.prefix_to_infix("+"), "+", "wrong output")
		assert_equal(Parser.prefix_to_infix("1 + 1"), "(+ 1 1)", "wrong output")
		assert_equal(Parser.prefix_to_infix("1 * 1"), "(* 1 1)", "wrong output")
		assert_equal(Parser.prefix_to_infix("2 * 5 + 1"), "(+ (* 2 5) 1)", "wrong output")
		assert_equal(Parser.prefix_to_infix("3 * x + ( 9 + y ) / 4"), "(+ (* 3 x) (/ (+ 9 y) 4))", "wrong output")
		assert_equal(Parser.prefix_to_infix("3 * x + ( 9 + y ) / 4"), Parser.prefix_to_infix("( 3 * x ) + ( ( 9 + y ) / 4 )"), "wrong output")

	end
end

class Parser
	# return a prefix expression for a given filepath containing infix expression	
	def self.run(filepath)
		prefix_to_infix File.read(filepath) if filepath
	end

	# return a prefix expression string for a given infix expression string
	def self.prefix_to_infix(datastring="")
		to_prefix parse_parenthesis split_string datastring
	end

	# return an array of values and operators for a given infix expression string
	def self.split_string(datastring = "")
		datastring.split(' ')
	end

	# return a parsed array of values and operators. Things "between" parenthesis should be returned in nested array(s)
	## examples :
	## parse_parenthesis(['(',2','+','3',')','*','4'])
	### => [['2','+','3'],'*','4']
	## parse_parenthesis(['(','(',2','+','3',')','*','4',')','*','3'])
	### => [[['2','+','3'],'*','4'],'*','3']
	def self.parse_parenthesis(array = [])
		parsed_array = []
		while array.any?
			case (item = array.shift)
			when '('
				parsed_array.push(parse_parenthesis(array))
			when ')'
				return parsed_array
			else
				parsed_array.push(item)
			end
		end
		parsed_array
	end

	# identity function for a string
	# return prefix value string for a given array representing an infix expression
	def self.to_prefix(value)
		return value if value.is_a? String
		return to_prefix value[0] if value.size == 1
		
		operator = value[1]
		
		if ['+','-'].include? operator
			"(#{operator} #{to_prefix value[0]} #{to_prefix value[2..-1]})"
		elsif ['*','/'].include? operator
			to_prefix (["(#{operator} #{to_prefix value[0]} #{ to_prefix value[2]})"] + value[3..-1])
		else
			""
		end
	end
end