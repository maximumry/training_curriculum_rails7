class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
  
    today = Date.today
    # 今日が週の何日目か（0: 日曜日、1: 月曜日, ..., 6: 土曜日）
    @todays_date = today.wday
  
    # 今週の月曜日から日曜日の日付を取得
    start_of_week = today - @todays_date
    end_of_week = start_of_week + 6
  
    @week_days = []
  
    plans = Plan.where(date: start_of_week..end_of_week)
  
    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == start_of_week + x
      end
  
      wday_num = start_of_week.wday + x
      wday_num = wday_num >= 7 ? wday_num - 7 : wday_num
  
      days = { 
        month: (start_of_week + x).month, 
        date: (start_of_week + x).day, 
        plans: today_plans, 
        wday: wdays[wday_num]  # 曜日を追記
      }
      @week_days.push(days)
    end
  end
  
end
