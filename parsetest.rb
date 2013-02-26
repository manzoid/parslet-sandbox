require 'parslet'
require 'awesome_print'
require './query_parser'
require './solr_query_transformer'
require './sql_query_transformer'

q='from:users'
q='from users where name:"joe" or name:"jack"'
q='from users where (name:"joe" or name:"jack")'
q='from users where app_id:"my_app" and (account_type:"beta" or account_type:"admin") and status:"1"'
q='app_id:"my_app"'
q='from users where app_id:"my_app"'
q='from users where app_id:"my_app" and account_type:"2"'

def parse(str)
  parser = QueryParser.new
  parser.parse(str)
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

tree=parse(q)
puts q << "\n\n"
ap tree 
ap SolrQueryTransformer.new.apply(tree);
#ap SQLQueryTransformer.new.apply(tree);0
