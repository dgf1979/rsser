class Hash
  def fetch_first_matching(array_of_params)
    array_of_params.each do |param|
      if self.key?(param)
        return self.fetch(param)
      end
    end
    return nil
  end
end
