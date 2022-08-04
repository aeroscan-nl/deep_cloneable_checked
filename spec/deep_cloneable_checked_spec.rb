RSpec.describe DeepCloneableChecked do
  it "has a version number" do
    expect(DeepCloneableChecked::VERSION).not_to be nil
  end

  it "should deep clone many_to_many associations" do
    @human = Animal::Human.create :name => 'Michael'
    @human2 = Animal::Human.create :name => 'Jack'
    @chicken1 = Animal::Chicken.create :name => 'Chick1'
    @chicken2 = Animal::Chicken.create :name => 'Chick2'
    @human.chickens << [@chicken1, @chicken2]
    @human2.chickens << [@chicken1, @chicken2]

    deep_clone_human = @human.deep_clone_checked(:include => :ownerships, :exclude => [:pigs, {:ownerships=>[:human, :chicken]}, :chickens])
    expect(deep_clone_human).to be_new_record
    expect(deep_clone_human.save).to be_truthy
    expect(deep_clone_human.chickens.count).to eq(2)
  end

  it "should raise an error if some associations are missing" do
    @human = Animal::Human.create :name => 'Michael'
    @human2 = Animal::Human.create :name => 'Jack'
    @chicken1 = Animal::Chicken.create :name => 'Chick1'
    @chicken2 = Animal::Chicken.create :name => 'Chick2'
    @human.chickens << [@chicken1, @chicken2]
    @human2.chickens << [@chicken1, @chicken2]

    expect do
      deep_clone_human = @human.deep_clone_checked(:include => :ownerships, :exclude => [:pigs, {:ownerships=>[:human]}, :chickens])
    end.to raise_error(DeepCloneableChecked::MissingAssociationError, "Not all associations cloned: [{:ownerships=>[:chicken]}]")
  end
end
