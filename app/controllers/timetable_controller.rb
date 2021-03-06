class TimetableController < ApplicationController

  before_filter :authorize, only: [:index, :regenerate]

  def index
    timetable = Timetable.by_user(current_user)
    @timetable = timetable.as_json
  end

  def regenerate
    current_user.generate_timetable_id
    current_user.save
    redirect_to action: "index"
  end

  def ical
    text = Timetable.to_ical(params[:timetable_id])
    render text: text, content_type: Mime::ICS
  end

  def exam
    @dates = EventDate.by_user(current_user).where(type: "exam").order(:start_time)
  end

end
