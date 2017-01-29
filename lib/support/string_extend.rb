class String
#capitalizes the first letter of every word
  def titelize
    self.split(' ').collect{|word| word.capitalize}.join(" ")
  end

end
