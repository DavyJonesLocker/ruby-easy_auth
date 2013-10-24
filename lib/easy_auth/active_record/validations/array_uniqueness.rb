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
    end
  end
end
