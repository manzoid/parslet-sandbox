# select * from users where (account_type = 'beta' or account_type = 'admin') and status='1'
class SQLQueryTransformer < Parslet::Transform
  rule(:or => { :left => subtree(:left), :right => subtree(:right) }) do
    s = "("
    if left
      if left.is_a?(Hash)
        #s << "LEFT: #{left.class} #{left} "
        keyword_pair = left[:keyword_pair]
        column = keyword_pair[:keyword]
        condition = keyword_pair[:target]
        s << "#{column}=#{condition} "
      else
        s << left
      end
    end
    if right
      s << " OR "
      #s << "RIGHT: #{right.class} #{right}  "
      if right.is_a?(Hash)
        keyword_pair = right[:keyword_pair]
        column = keyword_pair[:keyword]
        condition = keyword_pair[:target]
        s << "#{column}=#{condition} "
      else
        s << right
      end
    end
    s << ")"
  end

  rule(:and => { :left => subtree(:left), :right => subtree(:right) }) do
    s = "("
    if left
      if left.is_a?(Hash)
        #s << "LEFT: #{left.class} #{left} "
        keyword_pair = left[:keyword_pair]
        column = keyword_pair[:keyword]
        condition = keyword_pair[:target]
        s << "#{column}=#{condition} "
      else
        s << left
      end
    end
    if right
      s << " AND "
      #s << "RIGHT: #{right.class} #{right}  "
      if right.is_a?(Hash)
        keyword_pair = right[:keyword_pair]
        column = keyword_pair[:keyword]
        condition = keyword_pair[:target]
        s << "#{column}=#{condition} "
      else
        s << right
      end
    end
    s << ")"

  end

end