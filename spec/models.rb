module Animal
  class Human < ActiveRecord::Base
    has_many :pigs, autosave: true

    has_many :ownerships, autosave: true
    has_many :chickens, through: :ownerships, autosave: true
  end

  class Pig < ActiveRecord::Base
    belongs_to :human
  end

  class Bird < ActiveRecord::Base
    belongs_to :planet
  end

  class Chicken < Bird
    has_many :ownerships
    has_many :humans, :through => :ownerships
  end

  class Dove < Bird
  end

  class Planet < ActiveRecord::Base
    has_many :birds
  end

  class Ownership < ActiveRecord::Base
    belongs_to :human
    belongs_to :chicken

    validates_uniqueness_of :chicken_id, :scope => :human_id
  end
end