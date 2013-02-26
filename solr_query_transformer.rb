class SolrQueryTransformer < Parslet::Transform
  rule(:from => simple(:from_scope)) do
    "Search(#{from_scope.to_s.capitalize})"
  end
  
  rule(:or => { :left => subtree(:left), :right => subtree(:right) }) do
    # Solr disjunction is "any_of"
    s = "any_of do "
    if left
      if left.is_a?(Hash)
        #s << "LEFT: #{left.class} #{left} "
        keyword_pair = left[:keyword_pair]
        s << "  with(#{keyword_pair[:keyword]}).equal_to(#{keyword_pair[:target]}) "
      else
        s << left
      end
    end
    if right
      #s << "RIGHT: #{right.class} #{right}  "
      if right.is_a?(Hash)
        keyword_pair = right[:keyword_pair]
        s << "  with(#{keyword_pair[:keyword]}).equal_to(#{keyword_pair[:target]}) "
      else
        s << right
      end
    end
    s << "end "
  end

  rule(:and => { :left => subtree(:left), :right => subtree(:right) }) do
    # Solr conjunction is "all_of"
    s = "all_of do "
    if left
      if left.is_a?(Hash)
        #s << "LEFT: #{left.class} #{left} "
        keyword_pair = left[:keyword_pair]
        s << "  with(#{keyword_pair[:keyword]}).equal_to(#{keyword_pair[:target]}) "
      else
        s << left
      end
    end
    if right
      #s << "RIGHT: #{right.class} #{right}  "
      if right.is_a?(Hash)
        keyword_pair = right[:keyword_pair]
        s << "  with(#{keyword_pair[:keyword]}).equal_to(#{keyword_pair[:target]}) "
      else
        s << right
      end
    end
    s << "end "
  end
    
end