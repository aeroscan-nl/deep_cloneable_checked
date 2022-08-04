# frozen_string_literal: true

ActiveRecord::Schema.define(:version => 1) do
  create_table :pigs, :force => true do |t|
    t.column :name, :string
    t.column :human_id, :integer
  end

  create_table :humen, :force => true do |t|
    t.column :name, :string
  end

  create_table :planets, :force => true do |t|
    t.column :name, :string
  end

  create_table :birds, :force => true do |t|
    t.column :name, :string
    t.column :type, :string
    t.column :planet_id, :integer
  end

  create_table :ownerships, :force => true do |t|
    t.column :human_id, :integer
    t.column :chicken_id, :integer
  end
end
