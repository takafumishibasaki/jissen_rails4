class Message < ActiveRecord::Base

  belongs_to :customer
  belongs_to :staff_member
  belongs_to :root, class_name: 'Message', foreign_key: 'root_id'
  belongs_to :parent, class_name: 'Message', foreign_key: 'parent_id'

  validates :subject, :body, presence: true
  validates :subject, length: { maximum: 80, allow_blank: true }
  validates :subject, length: { maximum: 800, allow_blank: true }

  before_create do
    if parent
      self.customer = parent.customer
      self.root = parent.root || parent
    end
  end

  default_scope { order(created_at: :desc) }

  attr_accessor :child_nodes

  def tree
    return @tree if @tree
    r = root || self
    messages = Message.where(root_id: r.id).select(:id, :parent_id, :subject)
    @tree = SimpleTree.new(r, messages)
  end
end
