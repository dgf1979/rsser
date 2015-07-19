module FeedsHelper
  def fetch_first_matching(object, array_of_params)
    array_of_params.each do |param|
      if object.try(param)
        return object[param]
      end
    end
    return nil
  end
end
