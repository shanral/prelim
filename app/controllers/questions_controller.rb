class QuestionsController < ApplicationController
  def index
    @questions=Question.all
  end
  def create
    @question=Question.create!(params.require(:question).permit(:subject_id, :source_id, :year,:professor_id,:number,:term_id,:mini,:pdf))
    flash[:notice]="Question successfully created."
    redirect_to questions_path
  end
  def new
  end
end
