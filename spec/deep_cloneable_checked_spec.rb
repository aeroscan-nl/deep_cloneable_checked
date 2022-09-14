RSpec.describe DeepCloneableChecked do
  it "has a version number" do
    expect(DeepCloneableChecked::VERSION).not_to be nil
  end

  before :each do
    @human = Animal::Human.create :name => 'Michael'
    @human2 = Animal::Human.create :name => 'Jack'
    @chicken1 = Animal::Chicken.create :name => 'Chick1'
    @chicken2 = Animal::Chicken.create :name => 'Chick2'
    @human.chickens << [@chicken1, @chicken2]
    @human2.chickens << [@chicken1, @chicken2]
    @pig1 = Animal::Pig.create name: 'Pig1'
    @human.pigs << @pig1
  end


  def expect_human_correctly_cloned(deep_clone_human)
    expect(deep_clone_human).to be_new_record
    expect(deep_clone_human.save).to be_truthy
    expect(deep_clone_human.chickens.count).to eq(2)
  end

  def expect_human_fully_cloned(deep_clone_human)
    deep_clone_human.save!
    expect(deep_clone_human.id).not_to eq(@human.id)
    chicken1 = deep_clone_human.chickens.find_by(name: 'Chick1')
    expect(chicken1.id).not_to eq(@chicken1.id)
    pig1 = deep_clone_human.pigs.find_by(name: 'Pig1')
    expect(pig1.id).not_to eq(@pig1.id)
    expect(pig1.human_id).to eq(deep_clone_human.id)
    expect(chicken1.ownerships.count).to be(1)
    expect(chicken1.humans.first.id).to eq(deep_clone_human.id)
  end

  it "should be able to fully clone a complex object" do
    expect_human_fully_cloned @human.deep_clone_checked(
      :include => {
        pigs: [:human],
        ownerships: [:chicken, :human] 
      },
      :exclude => [
        ownerships: { chicken: [:planet, :ownerships] }
      ]
    )
  end

  it "should deep clone many_to_many associations" do
    expect_human_correctly_cloned @human.deep_clone_checked(:include => :ownerships, :exclude => [:pigs, {:ownerships=>[:human, :chicken]}, :chickens])
  end

  it "should deep clone with arguments in different style" do
    expect_human_correctly_cloned @human.deep_clone_checked(:include => [:ownerships], :exclude => [:pigs, {:ownerships=>[:human, :chicken]}, :chickens])
    expect_human_correctly_cloned @human.deep_clone_checked(:include => [{:ownerships => []}], :exclude => [:pigs, {:ownerships=>[:human, :chicken]}, :chickens])
  end

  it "should raise an error if an associations is missing" do
    expect do
      deep_clone_human = @human.deep_clone_checked(:include => [], :exclude => [:chickens, :ownerships])
    end.to raise_error(DeepCloneableChecked::MissingAssociationError, "Not all associations cloned: [:pigs]")
  end

  it "should raise an error if a deeper association is missing" do
    expect do
      deep_clone_human = @human.deep_clone_checked(:include => :ownerships, :exclude => [:pigs, {:ownerships=>[:human]}, :chickens])
    end.to raise_error(DeepCloneableChecked::MissingAssociationError, "Not all associations cloned: [{:ownerships=>[:chicken]}]")
  end

  it "should not raise an error on indirect associations" do
    expect do
      deep_clone_human = @human.deep_clone_checked(:include => :ownerships, :exclude => [:pigs, {:ownerships=>[:human, :chicken]} ])
    end.not_to raise_error
  end
end
