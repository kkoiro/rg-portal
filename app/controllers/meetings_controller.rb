class MeetingsController < ApplicationController
  include EmojiComplete
  include UserComplete
  before_action :require_active_current_user
  before_action :require_privilege, only: [:update, :destroy]
  before_action :set_meeting, only: [:edit, :update, :destroy]
  before_action :set_emoji_completion, only: [:new, :edit]
  before_action :set_user_completion, only: [:new, :edit]

  NUM_OF_MEETINGS_PER_PAGE = 20

  def index
    @meetings = Meeting.order(start_at: :desc).page(params[:page]).per(NUM_OF_MEETINGS_PER_PAGE)
  end

  def show
    @meeting = Meeting.includes(presentations: [:user, :handouts]).find(params[:id])
  end

  def new
    @meeting = Meeting.new
  end

  def create
    Meeting.new(meeting_params).save
    redirect_to meetings_path
  end

  def edit
  end

  def update
    if @meeting.update(meeting_params)
      redirect_to meeting_path(@meeting)
    else
      render :edit
    end
  end

  def destroy
    if @meeting.destroy
      redirect_to meetings_path, flash: { success: t('meetings.deleted_msg') }
    else
      redirect_to meeting_path(@meeting)
    end
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:name, :start_at, :end_at, :juried, :accepting, :content)
  end
end
