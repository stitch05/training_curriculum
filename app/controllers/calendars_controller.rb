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

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 今日の日付＝１２月１９日という情報が取得できている
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = Date.today.wday
      if wday_num < 7
        wday_num = wday_num -7
      end

      days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, :plans => today_plans, :wday => wdays[wday_num + x]}
      @week_days.push(days)
    end
# ブロック変数xには、１回目には０、２回目は１、、、と数字が増加していく
  # @todays_date + xは１回目に12月19日、２回目に12月20日、、、と増えていく 
  # Date today.wdayでは曜日情報を数値に変えて取得する→今日だったら、土曜日なので、数値は５になる
  # 配列wdaysの要素から添字を指定して取得する記述を行うwdays[2]
end
end
