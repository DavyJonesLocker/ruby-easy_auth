module ActiveRecord::Validations
  class ArrayUniquenessValidator < UniquenessValidator
    def build_relation(klass, table, attribute, value)
      if reflection = klass.reflect_on_association(attribute)
        attribute = reflection.foreign_key
        value = value.attributes[reflection.primary_key_column.name]
      end

      column = klass.columns_hash[attribute.to_s]
      value  = klass.connection.type_cast(value, column)
      value  = value.to_s[0, column.limit] if value && column.limit && column.text?

      table[attribute].overlap(value)
      # if !options[:case_sensitive] && value && column.text?
        # # will use SQL LOWER function before comparison, unless it detects a case insensitive collation
        # klass.connection.case_insensitive_comparison(table, attribute, column, value)
      # else
        # value = klass.connection.case_sensitive_modifier(value) unless value.nil?
        # table[attribute].eq(value)
      # end
    end
  end
end
