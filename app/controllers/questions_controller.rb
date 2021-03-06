class QuestionsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :find_question, only: [:show, :destroy, :edit, :update]

  def find_question
    @question = Question.find(params[:id])
  end

  def index
    @search = Question.includes(:sittings, :subject, :tags, :source, :professor, :terms).search(params[:q])
    @questions = @search.result.page(params[:page]).per(25)
    @search.build_condition if @search.conditions.empty?
    @search.build_sort if @search.sorts.empty?
    @current_user = current_user
  end

  def create
    @question = Question.new(question_params)
    @sitting = @question.sittings.build(params[:sitting].permit(:term_id, :year, :number))
    params[:tags][:id].each do |tag|
      if !tag.empty?
	      @question.questiontags.build(:tag_id => tag)
      end
    end
    if @question.save
      redirect_to questions_path
    end
  end

  def new
    @question = Question.new
    @all_tags = Tag.all.order(:tag)
    @questiontag = @question.questiontags.build
    @question_sitting = @question.sittings.build
  end

  def show
    @questiontag = Questiontag.new
    if current_user.finished_questions.where("question_id = ?", params[:id]).size > 0
      @finished_question = current_user.finished_questions.where("question_id = ?", params[:id]).first
    else
      @finished_question = FinishedQuestion.new
    end

    if current_user.question_ratings.where("question_id = ?", params[:id]).size > 0
      @question_rating = current_user.question_ratings.where("question_id = ?", params[:id]).first
    else
      @question_rating = QuestionRating.new
    end

  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def edit
  end

  def update
    if @question.update_attributes(question_params)
      flash[:success] = "Question updated"
      redirect_to :root
    else
      render 'edit'
    end
  end
end


private
  def question_params
    params.require(:question).permit(:subject_id, :source_id, :professor_id,:mini,:pdf)
    #params.require(:question).permit!
  end

  def sort_column
    #Question.column_names.include?(params[:sort]) ? params[:sort] : "subject_id"
                        params[:sort] || "subject_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
