# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `method_source` gem.
# Please instead update this file by running `bin/tapioca gem method_source`.

# source://method_source//lib/method_source.rb#163
class Method
  include ::MethodSource::SourceLocation::MethodExtensions
  include ::MethodSource::MethodExtensions
end

# source://method_source//lib/method_source/version.rb#1
module MethodSource
  extend ::MethodSource::CodeHelpers

  class << self
    # Clear cache.
    #
    # source://method_source//lib/method_source.rb#59
    def clear_cache; end

    # Helper method responsible for opening source file and buffering up
    # the comments for a specified method. Defined here to avoid polluting
    # `Method` class.
    #
    # @param source_location [Array] The array returned by Method#source_location
    # @param method_name [String]
    # @raise [SourceNotFoundError]
    # @return [String] The comments up to the point of the method.
    #
    # source://method_source//lib/method_source.rb#38
    def comment_helper(source_location, name = T.unsafe(nil)); end

    # @deprecated — use MethodSource::CodeHelpers#expression_at
    #
    # source://method_source//lib/method_source.rb#71
    def extract_code(source_location); end

    # Load a memoized copy of the lines in a file.
    #
    # @param file_name [String]
    # @param method_name [String]
    # @raise [SourceNotFoundError]
    # @return [Array<String>] the contents of the file
    #
    # source://method_source//lib/method_source.rb#51
    def lines_for(file_name, name = T.unsafe(nil)); end

    # Helper method responsible for extracting method body.
    # Defined here to avoid polluting `Method` class.
    #
    # @param source_location [Array] The array returned by Method#source_location
    # @param method_name [String]
    # @return [String] The method body
    #
    # source://method_source//lib/method_source.rb#23
    def source_helper(source_location, name = T.unsafe(nil)); end

    # @deprecated — use MethodSource::CodeHelpers#complete_expression?
    # @return [Boolean]
    #
    # source://method_source//lib/method_source.rb#64
    def valid_expression?(str); end
  end
end

# source://method_source//lib/method_source/code_helpers.rb#3
module MethodSource::CodeHelpers
  # Retrieve the comment describing the expression on the given line of the given file.
  #
  # This is useful to get module or method documentation.
  #
  # @param file [Array<String>, File, String] The file to parse, either as a File or as
  #   a String or an Array of lines.
  # @param line_number [Integer] The line number at which to look.
  #   NOTE: The first line in a file is line 1!
  # @return [String] The comment
  #
  # source://method_source//lib/method_source/code_helpers.rb#52
  def comment_describing(file, line_number); end

  # Determine if a string of code is a complete Ruby expression.
  #
  # @example
  #   complete_expression?("class Hello") #=> false
  #   complete_expression?("class Hello; end") #=> true
  #   complete_expression?("class 123") #=> SyntaxError: unexpected tINTEGER
  # @param code [String] The code to validate.
  # @raise [SyntaxError] Any SyntaxError that does not represent incompleteness.
  # @return [Boolean] Whether or not the code is a complete Ruby expression.
  #
  # source://method_source//lib/method_source/code_helpers.rb#66
  def complete_expression?(str); end

  # Retrieve the first expression starting on the given line of the given file.
  #
  # This is useful to get module or method source code.
  #
  #                           line 1!
  #
  # @option options
  # @option options
  # @param file [Array<String>, File, String] The file to parse, either as a File or as
  # @param line_number [Integer] The line number at which to look.
  #   NOTE: The first line in a file is
  # @param options [Hash] The optional configuration parameters.
  # @raise [SyntaxError] If the first complete expression can't be identified
  # @return [String] The first complete expression
  #
  # source://method_source//lib/method_source/code_helpers.rb#20
  def expression_at(file, line_number, options = T.unsafe(nil)); end

  private

  # Get the first expression from the input.
  #
  # @param lines [Array<String>]
  # @param consume [Integer] A number of lines to automatically
  #   consume (add to the expression buffer) without checking for validity.
  # @raise [SyntaxError]
  # @return [String] a valid ruby expression
  # @yield a clean-up function to run before checking for complete_expression
  #
  # source://method_source//lib/method_source/code_helpers.rb#92
  def extract_first_expression(lines, consume = T.unsafe(nil), &block); end

  # Get the last comment from the input.
  #
  # @param lines [Array<String>]
  # @return [String]
  #
  # source://method_source//lib/method_source/code_helpers.rb#106
  def extract_last_comment(lines); end
end

# An exception matcher that matches only subsets of SyntaxErrors that can be
# fixed by adding more input to the buffer.
#
# source://method_source//lib/method_source/code_helpers.rb#124
module MethodSource::CodeHelpers::IncompleteExpression
  class << self
    # source://method_source//lib/method_source/code_helpers.rb#137
    def ===(ex); end

    # @return [Boolean]
    #
    # source://method_source//lib/method_source/code_helpers.rb#149
    def rbx?; end
  end
end

# source://method_source//lib/method_source/code_helpers.rb#125
MethodSource::CodeHelpers::IncompleteExpression::GENERIC_REGEXPS = T.let(T.unsafe(nil), Array)

# source://method_source//lib/method_source/code_helpers.rb#133
MethodSource::CodeHelpers::IncompleteExpression::RBX_ONLY_REGEXPS = T.let(T.unsafe(nil), Array)

# This module is to be included by `Method` and `UnboundMethod` and
# provides the `#source` functionality
#
# source://method_source//lib/method_source.rb#77
module MethodSource::MethodExtensions
  # Return the comments associated with the method class/module.
  #
  # @example
  #   MethodSource::MethodExtensions.method(:included).module_comment
  #   =>
  #   # This module is to be included by `Method` and `UnboundMethod` and
  #   # provides the `#source` functionality
  # @raise SourceNotFoundException
  # @return [String] The method's comments as a string
  #
  # source://method_source//lib/method_source.rb#139
  def class_comment; end

  # Return the comments associated with the method as a string.
  #
  # @example
  #   Set.instance_method(:clear).comment.display
  #   =>
  #   # Removes all elements and returns self.
  # @raise SourceNotFoundException
  # @return [String] The method's comments as a string
  #
  # source://method_source//lib/method_source.rb#126
  def comment; end

  # Return the comments associated with the method class/module.
  #
  # @example
  #   MethodSource::MethodExtensions.method(:included).module_comment
  #   =>
  #   # This module is to be included by `Method` and `UnboundMethod` and
  #   # provides the `#source` functionality
  # @raise SourceNotFoundException
  # @return [String] The method's comments as a string
  #
  # source://method_source//lib/method_source.rb#139
  def module_comment; end

  # Return the sourcecode for the method as a string
  #
  # @example
  #   Set.instance_method(:clear).source.display
  #   =>
  #   def clear
  #   @hash.clear
  #   self
  #   end
  # @raise SourceNotFoundException
  # @return [String] The method sourcecode as a string
  #
  # source://method_source//lib/method_source.rb#114
  def source; end

  class << self
    # We use the included hook to patch Method#source on rubinius.
    # We need to use the included hook as Rubinius defines a `source`
    # on Method so including a module will have no effect (as it's
    # higher up the MRO).
    #
    # @param klass [Class] The class that includes the module.
    #
    # source://method_source//lib/method_source.rb#84
    def included(klass); end
  end
end

# source://method_source//lib/method_source/source_location.rb#2
module MethodSource::ReeSourceLocation
  # Ruby enterprise edition provides all the information that's
  # needed, in a slightly different way.
  #
  # source://method_source//lib/method_source/source_location.rb#5
  def source_location; end
end

# source://method_source//lib/method_source/source_location.rb#10
module MethodSource::SourceLocation; end

# source://method_source//lib/method_source/source_location.rb#11
module MethodSource::SourceLocation::MethodExtensions
  # Return the source location of a method for Ruby 1.8.
  #
  # @return [Array] A two element array. First element is the
  #   file, second element is the line in the file where the
  #   method definition is found.
  #
  # source://method_source//lib/method_source/source_location.rb#40
  def source_location; end

  private

  # source://method_source//lib/method_source/source_location.rb#26
  def trace_func(event, file, line, id, binding, classname); end
end

# source://method_source//lib/method_source/source_location.rb#54
module MethodSource::SourceLocation::ProcExtensions
  # Return the source location for a Proc (in implementations
  # without Proc#source_location)
  #
  # @return [Array] A two element array. First element is the
  #   file, second element is the line in the file where the
  #   proc definition is found.
  #
  # source://method_source//lib/method_source/source_location.rb#74
  def source_location; end
end

# source://method_source//lib/method_source/source_location.rb#81
module MethodSource::SourceLocation::UnboundMethodExtensions
  # Return the source location of an instance method for Ruby 1.8.
  #
  # @return [Array] A two element array. First element is the
  #   file, second element is the line in the file where the
  #   method definition is found.
  #
  # source://method_source//lib/method_source/source_location.rb#101
  def source_location; end
end

# An Exception to mark errors that were raised trying to find the source from
# a given source_location.
#
# source://method_source//lib/method_source.rb#16
class MethodSource::SourceNotFoundError < ::StandardError; end

# source://method_source//lib/method_source/version.rb#2
MethodSource::VERSION = T.let(T.unsafe(nil), String)

# source://method_source//lib/method_source.rb#173
class Proc
  include ::MethodSource::SourceLocation::ProcExtensions
  include ::MethodSource::MethodExtensions
end

# source://method_source//lib/method_source.rb#168
class UnboundMethod
  include ::MethodSource::SourceLocation::UnboundMethodExtensions
  include ::MethodSource::MethodExtensions
end
