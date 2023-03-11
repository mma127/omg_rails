require 'csv'

after :units do
  def snakecase(str)
    str.parameterize.underscore
  end


end
