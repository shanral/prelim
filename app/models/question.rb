class Question < ActiveRecord::Base
  belongs_to :subject
  belongs_to :source
  belongs_to :professor
  validates :source, :subject, presence: true
  has_many :sittings
  has_many :question_ratings
  has_many :answers
  accepts_nested_attributes_for :sittings
  has_attached_file :pdf
  
end
