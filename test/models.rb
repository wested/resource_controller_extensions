ActiveRecord::Base.establish_connection :adapter  => 'sqlite3', :database => File.join(File.dirname(__FILE__), 'test.db')

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :projects, :force => true do |t|
      t.string :name
      t.integer :position
    end
    create_table :tasks, :force => true do |t|
      t.string :name
      t.integer :project_id
      t.integer :person_id
      t.boolean :complete
    end
    create_table :category_projects, :force => true do |t|
      t.integer :project_id
      t.integer :category_id
    end
    create_table :categories, :force => true do |t|
      t.string :name
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Project < ActiveRecord::Base
  validates_presence_of :name
  has_many :tasks
  has_many :category_projects
  has_many :categories, :through => :category_projects
end

class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
end

class CategoryProject < ActiveRecord::Base
  belongs_to :category
  belongs_to :project
end

class Category < ActiveRecord::Base
  has_many :category_projects
  has_many :projects, :through => :category_projects
end