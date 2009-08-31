module SqlQuery
  
  def self.included(base)
    base.extend(SqlQuery::ClassMethods)
  end
  
  module ClassMethods
    
    def sql_query(options={})
      if options[:fields].nil?
        options[:fields] = []
        self.columns.each do |column|
          options[:fields] << column.name.to_s if [:string, :text].include?(column.type)
        end
      end
      cons_array = []
      options[:fields].each do |field|
        cons_array << " #{field} like :query"
      end
      cons = cons_array.join(' or ')
      named_scope :sql_search, lambda { |query|
        h = {}
        h[:query] = "%#{query}%"
        { :conditions => [cons, h]}
      }
    end
    
  end
  
end
