# == Schema Information
#
# Table name: questions
#
#  id               :integer          not null, primary key
#  subject_id       :integer
#  source_id        :integer
#  professor_id     :integer
#  mini             :integer
#  created_at       :datetime
#  updated_at       :datetime
#  pdf_file_name    :string(255)
#  pdf_content_type :string(255)
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#  answers_count    :integer          default(0)
#  overall          :float            default(3.0)
#  difficulty       :float            default(3.0)
#  uniqueness       :float            default(3.0)
#

## Association to the Question Table
class Question < ActiveRecord::Base
  belongs_to :subject
  belongs_to :source
  belongs_to :professor
  validates :source, :subject, presence: true
  has_many :sittings, dependent: :destroy
  has_many :question_ratings, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :finished_questions, dependent: :destroy
  has_many :tags, through: :questiontags
  has_many :terms, through: :sittings
  has_many :questiontags, dependent: :destroy
  accepts_nested_attributes_for :sittings
  has_attached_file :pdf
  after_create :update_question_ratings

  def update_question_ratings
    @ratings = QuestionRating.where(question_id: id)
    self.overall = @ratings.average(:overall)
    self.difficulty = @ratings.average(:difficulty)
    self.uniqueness = @ratings.average(:uniqueness)
    self.save!
  end

  def total_answers
    answers.size
  end

  def subj
    subject.name
  end

  def prof
    professor.name
  end

  def last_date
    @sittings = sittings.sort_by { |u| u.year }
    @sitting = @sittings.last
    @sitting.sort_sitting
  end
end
