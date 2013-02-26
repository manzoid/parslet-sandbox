class QueryParser < Parslet::Parser
  rule(:space)  { match[" "].repeat(1) }
  rule(:space?) { space.maybe }
  rule(:lparen) { str("(") >> space? }
  rule(:rparen) { str(")") >> space? }
  rule(:and_operator) { str("and") >> space? }
  rule(:or_operator)  { str("or")  >> space? }
  rule(:quote) { match['"'].repeat(1) }
  rule(:not_quote) { match['^"'].repeat(1) }
  rule(:colon) { match[":"].repeat(1) }

  # We expect query parts to be expressed in colon-delimited keyword/target pairs. 
  # Keywords can have letters and underscores.
  rule(:keyword) { match("\\w").repeat(1).as(:keyword) >> space? }
  # Targets must arrive quoted, so there is no ambiguity around multi-word targets.
  # TODO: Handle targets containing quotes.
  rule(:target) { quote >> not_quote.as(:target) >> quote >> space? }
  rule(:keyword_pair) { (keyword >> colon >> target).as(:keyword_pair)}

  # Handle parentheses.
  rule(:query_part) { lparen >> or_operation >> rparen | keyword_pair | target}

  # AND and OR.
  # These are right-recursive (examine the parse output to see what this means in practice).
  rule(:and_operation_or_query_part) {
    ( query_part.as(:left) >> and_operator >> and_operation_or_query_part.as(:right) ).as(:and) |
    query_part }

  # OR's pull in AND's, AND's pull in query parts, query parts pull in OR's again, rinse and repeat.
  rule(:or_operation)  { 
    ( and_operation_or_query_part.as(:left) >> or_operator >> or_operation.as(:right) ).as(:or) |
    and_operation_or_query_part }

  # The pattern we eventually want to be able to consume:
  # SELECT [col1,col2,col3] FROM [scope] WHERE [cond1] AND [cond2] AND ([cond3] OR [cond4])
  # The pattern we can currently consume
  # FROM [scope] WHERE [cond1] AND [cond2] AND ([cond3] OR [cond4])

  rule(:from) { str("from") >> space >> match("\\w").repeat(1).as(:from) >> space? }
  rule(:where) { str("where") >> space? }
  rule(:chunk) { from | where | or_operation }
  rule(:chunks) { chunk.repeat }

  root(:chunks)
end